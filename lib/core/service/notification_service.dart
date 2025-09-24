import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._();
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  NotificationService._();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(initializationSettings);

    // Request notification permissions
    await FirebaseMessaging.instance.requestPermission();
  }

  Future<void> showNotification(
      String title, String body, String notificationId) async {
    // ✅ Read stored notification IDs
    String? storedIds = await _storage.read(key: 'shown_notification_ids');
    List<String> shownIds = storedIds != null
        ? (jsonDecode(storedIds) as List<dynamic>).cast<String>()
        : [];

    // ✅ Check if notification is already shown
    if (shownIds.contains(notificationId)) {
      print("🔄 Notification already shown: $notificationId");
      return;
    }

    // ✅ Add new notification ID to storage
    shownIds.add(notificationId);
    await _storage.write(
        key: 'shown_notification_ids', value: jsonEncode(shownIds));

    // ✅ Show notification only once
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'sadqahzakaat_channel',
      'SadqahZakaat Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotifications.show(
      notificationId.hashCode, // Unique ID for each notification
      title,
      body,
      platformChannelSpecifics,
      payload: jsonEncode({'title': title, 'body': body}),
    );
  }
}
