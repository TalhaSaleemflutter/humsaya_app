// lib/models/notification_model.dart
import 'package:hive/hive.dart';
part 'notification_model.g.dart';

@HiveType(typeId: 3) // Unique Hive typeId
class NotificationModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String body;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });

  /// ✅ Create NotificationModel from Firebase message data
  factory NotificationModel.fromFirebaseData(Map<String, dynamic> data) {
    return NotificationModel(
      id: data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title:
          data['title'] ?? data['notification']?['title'] ?? 'New Notification',
      body: data['body'] ?? data['notification']?['body'] ?? '',
      timestamp: DateTime.now(),
      isRead: false,
    );
  }

  /// Optional: For logging/debugging
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'timestamp': timestamp.toIso8601String(),
    'isRead': isRead,
  };

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
    );
  }
}
