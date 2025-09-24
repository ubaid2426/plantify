import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:plant_app/components/navigation.dart';
import 'package:plant_app/models/oder_detail.dart';
import 'package:plant_app/models/payment_detail.dart';
import 'package:plant_app/screens/Login/Screen/login_page.dart';

const storage = FlutterSecureStorage();

class PaymentMethod extends StatefulWidget {
  final String? id;
  final String? amount;
  final String? selectcategory;
  final String? quantity;
  final double? unitprice;
  const PaymentMethod({
    super.key,
    this.amount,
    this.quantity,
    this.selectcategory,
    this.unitprice,
    this.id,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  File? imageFile;
  late Future<String> paymentStatus;
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController userIdController = TextEditingController();
  // bool isLoading = true;
  bool isUpdating = false;
  String errorMessage = '';
  @override
  void initState() {
    super.initState();
    paymentStatus = fetchPaymentStatus();
    _checkAccessToken();
  }

  // Fetch Payment Status
  Future<String> fetchPaymentStatus() async {
    try {
      String? donorId = await storage.read(key: 'user_id');
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/data/donor-history/$donorId/status/'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['payment_status'] ?? 'Unknown';
      }
      return 'Failed to load status';
    } catch (e) {
      return 'Error: $e';
    }
  }

  double _calculateTotalP() {
    // Convert placeholderText to double
    final double subtotal = double.tryParse(widget.amount.toString()) ?? 0.9;
    const double taxRate = 0.05; // 5% tax

    // Calculate total
    final double total = subtotal + (subtotal * taxRate);

    return total;
  }

Future<void> placeOrder() async {
  String? token = await storage.read(key: 'access_token');
  if (token == null) {
    showMessage('Error: Missing user token.');
    return;
  }

  try {
    // Example: multiple values passed as comma-separated strings in widget
    List<String> idList =
        widget.id!.split(',').map((e) => e.trim()).toList();
    List<String> quantityList =
        widget.quantity!.split(',').map((e) => e.trim()).toList();

    // Convert to List<Map<String, dynamic>>
    final productsList = <Map<String, dynamic>>[];
    for (int i = 0; i < idList.length; i++) {
      productsList.add({
        "id": int.tryParse(idList[i]) ?? 0,
        "quantity": int.tryParse(quantityList[i]) ?? 1,
      });
    }

    // Wrap payload in JSON
    final payload = {
      "order_data": {
        "products": productsList,
        "payment_status": "pending",
      }
    };

    // Multipart request (for optional payment image)
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/plantinfo/plantinfo/orders/purchase/'),
    );

    request.headers['Authorization'] = 'JWT $token';
    request.fields['order_data'] = jsonEncode(payload['order_data']);

    if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'payment_image',
        imageFile!.path,
      ));
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201 || response.statusCode == 200) {
      showMessage('Order placed successfully');
      _showSuccessDialog(context);
    } else {
      showMessage(
          'Failed: ${response.statusCode}, Body: $responseBody');
    }
  } catch (e) {
    showMessage('Error placing order: $e');
  }
}


  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Add rounded corners
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle,
                color: Colors.green, size: 28), // Success icon
            SizedBox(width: 10),
            Text(
              'Success',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Your donation has been sent for verification once approve you will receive notification',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87, // Softer color for content
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Navigation()),
              );
              // context.read<NotificationBloc>().add(FetchNotifications());
            },
            child: const Text(
              'OK',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showloginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content:
            const Text('Please log in to access and continue your donation'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchUserDetails(String token) async {
    setState(() {
      isLoading = true;
    });

    try {
      var url = Uri.parse('http://127.0.0.1:8000/api/auth/users/me/');
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'JWT $token',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          nameController.text = data['name'] ?? 'N/A';
          emailController.text = data['email'] ?? 'N/A';
          userIdController.text = data['id'].toString();
          isLoading = false;
        });
      } else {
        _showloginDialog();
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error occurred: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _checkAccessToken() async {
    setState(() {
      isLoading = true;
    });

    String? token = await storage.read(key: 'access_token');
    if (token == null) {
      _showloginDialog();
    } else {
      _fetchUserDetails(token);
    }
  }

  // Pick and Process Image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() => imageFile = File(pickedFile.path));
      await checkImageSize(imageFile!);
    } else {
      showMessage('No image selected.');
    }
  }

  Future<void> checkImageSize(File image) async {
    final fileSizeMB = image.lengthSync() / (1024 * 1024);
    if (fileSizeMB > 2) {
      await resizeImage(image);
    } else {
      uploadImage();
    }
  }

  Future<void> resizeImage(File image) async {
    try {
      final decodedImage = img.decodeImage(image.readAsBytesSync());
      if (decodedImage != null) {
        final resizedImage = img.copyResize(decodedImage, width: 400);
        final resizedFile = File(image.path)
          ..writeAsBytesSync(img.encodeJpg(resizedImage));
        setState(() => imageFile = resizedFile);
        uploadImage();
      }
    } catch (e) {
      showMessage('Error resizing image: $e');
    }
  }

  void uploadImage() {
    showMessage('Image ready for upload.');
  }

  // Show Snackbar
  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget buildPaymentMethodCard({
    required String title,
    required String accountNumber,
    required String bankName,
    required String accountHolder,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Glassmorphism Background
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.05)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border:
                  Border.all(color: Colors.white.withOpacity(0.3), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Floating Circle
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(icon, size: 30, color: Colors.white),
                    ),
                    const SizedBox(width: 15),
                    AutoSizeText(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // Account Details
                _buildInfoRow('Account Number', accountNumber),
                _buildInfoRow('Bank Name', bankName),
                _buildInfoRow('Account Holder', accountHolder),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Helper function for beautiful text rows
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Payment Screenshot:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        imageFile == null
            ? const Text('No image selected.')
            : Image.file(imageFile!, height: 300, fit: BoxFit.cover),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
            icon: const Icon(Icons.payment, color: Colors.white),
            label: const Text(
              "Upload Payment Image",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            onPressed: _pickImage,
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.black,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF33A248),
        title: const Text('Payment Methods'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF33A248), Color(0xFFB2EA50)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildPaymentMethodCard(
                title: 'Local Bank Transfer',
                accountNumber: '308218383wew232000001023',
                bankName: 'Faysal Bank',
                accountHolder: 'M. Shahid',
                icon: FontAwesomeIcons.buildingColumns,
              ),
              const SizedBox(height: 20),
              buildPaymentMethodCard(
                title: 'International Donors',
                accountNumber: 'PK08FAYS322112301000w23212002475',
                bankName: 'Faysal Bank',
                accountHolder: 'Plantify Nursery',
                icon: FontAwesomeIcons.globe,
              ),
              const SizedBox(height: 20),
              buildPaymentMethodCard(
                title: 'Jazzcash',
                accountNumber: '0336334332087',
                bankName: 'Jazzcash',
                accountHolder: 'M. Shahid',
                // ignore: deprecated_member_use
                icon: FontAwesomeIcons.mobileAlt,
              ),
              const SizedBox(height: 20),
              buildPaymentMethodCard(
                title: 'Sadapay & Easypaisa',
                accountNumber: '0336-35874327',
                bankName: 'Sadapay & Easypaisa',
                accountHolder: 'M. Shahid',
                // ignore: deprecated_member_use
                icon: FontAwesomeIcons.mobileAlt,
              ),
              const SizedBox(height: 20),
              buildPaymentMethodCard(
                title: 'PayPal (For International)',
                accountNumber: 'paypal@gmail.com',
                bankName: 'PayPal',
                accountHolder: 'M. Shahid',
                icon: FontAwesomeIcons.paypal,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildRow('Subtotal', "Rs. ${widget.amount.toString()}"),
                    const SizedBox(height: 10),
                    _buildRow('Services Charges',
                        "5%"), // Assuming no taxes for donations
                    const Divider(
                        thickness: 4.0, height: 30.0, color: Colors.black),
                    _buildRow(
                      'Total',
                      "Rs. ${_calculateTotalP()}",
                      isBold: true,
                    ),
                    const SizedBox(height: 30),
                    buildImagePicker(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                  ),
                  icon: const Icon(Icons.payment, color: Colors.white),
                  label: const Text(
                    "Donate",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onPressed: placeOrder,
                ),
              ),
              const SizedBox(height: 40),
              // Center(
              //   child: CustomButton(
              //     title: "Donate",
              //     icon: FontAwesomeIcons.moneyCheck,
              //     onNavigate: recordDonation,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
