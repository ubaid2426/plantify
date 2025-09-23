import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sadqahzakat/Screens/Notification/Screen/Bloc/notification_event.dart';
import 'package:sadqahzakat/Screens/Notification/Screen/Bloc/notification_state.dart';
import 'package:sadqahzakat/model/notification_model.dart';
import 'package:sadqahzakat/services/notification_service.dart';

// part 'notification_event.dart';
// part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final storage = const FlutterSecureStorage();

  NotificationBloc() : super(NotificationLoading()) {
    on<FetchNotifications>(_fetchNotifications);
  }

  Future<void> _fetchNotifications(
      FetchNotifications event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());

    String? token = await storage.read(key: 'access_token');
    final url = Uri.parse('https://sadqahzakaat.com/data/notifications/');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'JWT $token'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<NotificationModel> notifications =
            data.map((json) => NotificationModel.fromJson(json)).toList();
        // Show notifications in the tray for unread messages
        for (var notification in notifications) {
        String notificationId = notification.id.toString();
          if (!notification.isRead) {
            NotificationService.instance.showNotification(
              notification.title,
              notification.message,
              notificationId
            );
          }
        }

        emit(NotificationLoaded(notifications));
      } else {
        emit(NotificationError("Failed to load notifications"));
      }
    } catch (e) {
      emit(NotificationError("Error: ${e.toString()}"));
    }
  }
}
