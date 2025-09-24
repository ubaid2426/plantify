
class NotificationModel {
  final int id;
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  // ✅ Add copyWith method
  NotificationModel copyWith({
    int? id,
    String? title,
    String? message,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

factory NotificationModel.fromJson(Map<String, dynamic> json) {
  try {
    return NotificationModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? "No Title",
      message: json['message'] ?? "No Message",
      isRead: json['is_read'] ?? false, // Ensure this matches the API field
      createdAt: DateTime.tryParse(json['created_at'] ?? "") ?? DateTime.now(),
    );
  } catch (e) {
    throw Exception("Failed to parse notification data.");
  }
}
}
