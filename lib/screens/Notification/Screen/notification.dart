import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plant_app/screens/Notification/Screen/Bloc/notification_bloc.dart';
import 'package:plant_app/screens/Notification/Screen/Bloc/notification_event.dart';
import 'package:plant_app/screens/Notification/Screen/Bloc/notification_state.dart';
// import 'package:sadqahzakat/Screens/Notification/Screen/Bloc/notification_bloc.dart';
// import 'package:sadqahzakat/Screens/Notification/Screen/Bloc/notification_event.dart';
// import 'package:sadqahzakat/Screens/Notification/Screen/Bloc/notification_state.dart';
// import 'package:sadqahzakat/model/notification_model.dart';
// import 'package:sadqahzakat/services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(FetchNotifications());
    markAllNotificationsAsSeen();
  }

  Future<void> markAllNotificationsAsSeen() async {
    String? token = await storage.read(key: 'access_token');
    // print(token);
    final url = Uri.parse('https://sadqahzakaat.com/data/notifications/');
    await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
      body: jsonEncode({'is_read': true}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
    body: BlocBuilder<NotificationBloc, NotificationState>(
  builder: (context, state) {
    if (state is NotificationLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is NotificationLoaded) {
      return _buildNotificationList(state.notifications);
    } else if (state is NotificationError) {
      return _buildErrorMessage(state.message);
    }
    return _buildEmptyMessage();
  },
),

    );
  }

  // 🔹 Custom App Bar with Gradient
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text("Notifications",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF33A248), // First color (#33A248)
              Color(0xFFB2EA50), // Second color (#B2EA50)
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
      ),
    );
  }

  // 🔹 Notification List UI
  Widget _buildNotificationList(List<NotificationModel> notifications) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications.reversed.toList()[index];
        // NotificationService.instance.showLocalNotification(notification.title, notification.message, data: notifications);
        // final notification = notifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  // 🔹 Beautiful Card Design for Notifications
  Widget _buildNotificationCard(NotificationModel notification) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: notification.isRead
            ? Colors.white
            : Colors.blue[50], // Highlight unread notifications
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Text(
          notification.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          notification.message,
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ),
        leading: CircleAvatar(
          backgroundColor:
              notification.isRead ? Colors.grey[400] : const Color(0xFF7fc23a),
          child: Icon(
            notification.isRead ? Icons.done : Icons.notifications_active,
            color: Colors.white,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.check_circle, color: Color(0xFF7fc23a)),
          onPressed: () {
            context
                .read<NotificationBloc>()
                .add(MarkNotificationRead(notification.id));
          },
        ),
      ),
    );
  }

  // 🔹 Show Empty State
  Widget _buildEmptyMessage() {
    return const Center(
      child: Text(
        "No notifications found",
        style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 10, 10, 10)),
      ),
    );
  }

  // 🔹 Show Error Message
  Widget _buildErrorMessage(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(fontSize: 16, color: Colors.red),
      ),
    );
  }
}

