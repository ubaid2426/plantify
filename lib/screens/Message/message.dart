import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart'; // For image and video picking
import 'dart:io'; // To handle file inputs
import 'package:http/http.dart' as http; // To handle backend API
import 'package:geolocator/geolocator.dart';
import 'package:plant_app/screens/Message/user_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// Create storage
final storage = FlutterSecureStorage();
class Message extends StatefulWidget {
  const Message({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  List<Message1> messages = [];
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker(); // Image picker instance
  String? donorName;
  int? donorId;
  bool isLoading = true;

  // Format the time to display in 'hh:mm a' format
  String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  // Function to load donor details
  Future<void> _loadDonorDetails() async {
    var userDetails = await UserService.fetchUserDetails();
    if (userDetails != null) {
      setState(() {
        donorName = userDetails['name'];
        donorId = userDetails['id'];
        isLoading = false;
      });
      fetchMessages(); // Fetch previous messages
    } else {
      // print("Error fetching donor details.");
    }
  }

  // Fetch previous messages from the backend
  Future<void> fetchMessages() async {
    String? token = await storage.read(key: 'access_token');

    if (token == null) {
      // print("Token not found.");
      return;
    }

    var response = await http.get(
      Uri.parse('https://sadqahzakaat.com/chat/message/retrieve/'),
      headers: {'Authorization': 'JWT $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> messageData = jsonDecode(response.body);

      setState(() {
        messages = messageData.map((data) {
          String text = data['text'] is String ? data['text'] : '';
          String sender = data['sender'] is String ? data['sender'] : 'Unknown';
          // print(sender);
          int senderId = data['sender'] is int ? data['sender'] : -1;
          // print(senderId);
          bool seen = data['seen'] is bool ? data['seen'] : false;
          // Parse the timestamp correctly
          DateTime messageTime;
          try {
            messageTime = DateTime.parse(data['timestamp']);
          } catch (e) {
            messageTime = DateTime.now(); // Use current time if parsing fails
          }
          return Message1(
            text: text,
            sender: sender,
            senderId: senderId,
            seen: seen,
            time: messageTime,
            type: data['type'] ??
                'text', // Check message type (text, image, video, etc.)
            mediaUrl: data['media_url'], // Handle media URL if exists
          );
        }).toList();
        // print(senderId);
      });
    } else {
      // print("Failed to fetch messages: ${response.statusCode}");
    }
  }

  // Send text message
  Future<void> sendMessage(String text) async {
    if (text.isEmpty || donorName == null || donorId == null) return;

    String? token = await storage.read(key: 'access_token');

    if (token == null) {
      // print("Token not found, unable to send message.");
      return;
    }

    var response = await http.post(
      Uri.parse('https://sadqahzakaat.com/chat/message/'),
      headers: {
        'Authorization': 'JWT $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'text': text,
        'sender': donorName,
        'sender_id': donorId,
        'type': 'text', // Sending as a text message
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        messages.add(Message1(
          text: text,
          sender: donorName ?? 'Donor',
          senderId: donorId ?? -1,
          seen: false,
          time: DateTime.now(),
          type: 'text',
        ));
      });
      _controller.clear();
    } else {
      // print("Failed to send message: ${response.statusCode}");
    }
  }

  // Pick and send an image
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      uploadMedia(imageFile, 'image');
    }
  }

  // Pick and send a video
  Future<void> pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      File videoFile = File(pickedFile.path);
      uploadMedia(videoFile, 'video');
    }
  }

  // Send media to the backend (image/video)
  Future<void> uploadMedia(File file, String type) async {
    String? token = await storage.read(key: 'access_token');

    if (token == null) {
      // print("Token not found.");
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://sadqahzakaat.com/chat/message/'),
    );
    request.headers['Authorization'] = 'JWT $token';
    request.files.add(await http.MultipartFile.fromPath(type, file.path));
    request.fields['sender'] = donorName!;
    request.fields['sender_id'] = donorId.toString();
    request.fields['type'] = type; // Indicate whether it's 'image' or 'video'

    var response = await request.send();

    if (response.statusCode == 201) {
      setState(() {
        messages.add(Message1(
          text: '$type uploaded',
          sender: donorName!,
          senderId: donorId ?? -1,
          seen: false,
          time: DateTime.now(),
          type: type, // Store the type (image/video)
        ));
      });
    } else {
      // print("Failed to upload $type: ${response.statusCode}");
    }
  }

  // Pick and send location
  Future<void> pickLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);
    String location = '${position.latitude}, ${position.longitude}';
    sendMessage('Location: $location');
  }

  @override
  void initState() {
    super.initState();
    _loadDonorDetails(); // Load donor details and fetch previous messages
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF33A248), Color(0xFFB2EA50)],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];

                // Determine if the message is from the donor (align right) or admin (align left)
                bool isDonorMessage = message.senderId == donorId;

                // Different message layout for image, video, and text
                Widget messageContent;
                if (message.type == 'image') {
                  messageContent = Image.network(
                    message.mediaUrl ?? '',
                    fit: BoxFit.cover,
                  );
                } else if (message.type == 'video') {
                  messageContent =
                      const Icon(Icons.videocam); // Placeholder for video
                } else {
                  messageContent = Text(message.text);
                }

                return ListTile(
                  contentPadding: isDonorMessage
                      ? const EdgeInsets.only(
                          left: 50, right: 10) // Donor's messages (align right)
                      : const EdgeInsets.only(
                          left: 10, right: 50), // Admin's messages (align left)

                  leading:
                      !isDonorMessage // Admin's messages should have leading avatar
                          ? const CircleAvatar(
                              child: Icon(Icons.admin_panel_settings))
                          : null, // Donor's messages shouldn't have leading avatar

                  trailing:
                      isDonorMessage // Donor's messages should have trailing avatar
                          ? const CircleAvatar(child: Icon(Icons.person))
                          : null, // Admin's messages shouldn't have trailing avatar

                  title: Align(
                    alignment: isDonorMessage
                        ? Alignment.centerRight
                        : Alignment
                            .centerLeft, // Align donor/admin messages accordingly
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDonorMessage
                            ? Colors.green[
                                100] // Donor's messages in greenish color
                            : Colors
                                .grey[200], // Admin's messages in greyish color
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          messageContent, // Show message content based on type (text, image, video)
                          const SizedBox(height: 5),
                          Text(
                            formatTime(message.time), // Display message time
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
                    Padding(
            padding: const EdgeInsets.only(bottom: 120, top: 10, left: 10, right: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image, color: Color(0xFF7fc23a)),
                    onPressed: pickImage,
                  ),
                  IconButton(
                    icon: const Icon(Icons.videocam, color: Colors.redAccent),
                    onPressed: pickVideo,
                  ),
                  IconButton(
                    icon: const Icon(Icons.location_on, color: Colors.green),
                    onPressed: pickLocation,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter your message...',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF7fc23a),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () => sendMessage(_controller.text),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.only(bottom: 120, top: 10, left: 10, right:10),
          //   child: Row(
          //     children: [
          //       IconButton(
          //         icon: const Icon(Icons.image),
          //         onPressed: pickImage,
          //       ),
          //       IconButton(
          //         icon: const Icon(Icons.videocam),
          //         onPressed: pickVideo,
          //       ),
          //       IconButton(
          //         icon: const Icon(Icons.location_on),
          //         onPressed: pickLocation,
          //       ),
          //       Expanded(
          //         child: TextField(
          //           controller: _controller,
          //           decoration: const InputDecoration(
          //             hintText: 'Enter your message...',
          //           ),
          //         ),
          //       ),
          //       IconButton(
          //         icon: const Icon(Icons.send),
          //         onPressed: () => sendMessage(_controller.text),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class Message1 {
  final String text;
  final String sender;
  final int senderId;
  final bool seen;
  final DateTime time;
  final String type; // Type of message: text, image, video
  final String? mediaUrl; // For image or video URLs

  Message1({
    required this.text,
    required this.sender,
    required this.senderId,
    required this.seen,
    required this.time,
    required this.type,
    this.mediaUrl,
  });
}
