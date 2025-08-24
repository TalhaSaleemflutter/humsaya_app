  // lib/services/notification_storage.dart
  import 'package:hive/hive.dart';
  import 'package:humsaya_app/models/notification_model.dart';

  class NotificationStorage {
    static const String _boxName = 'notifications_box';

    static Future<Box<NotificationModel>> _openBox() async {
      if (!Hive.isAdapterRegistered(2)) {
        Hive.registerAdapter(NotificationModelAdapter());
      }
      return await Hive.openBox<NotificationModel>(_boxName);
    }

    static Future<void> addNotification(NotificationModel notification) async {
      final box = await _openBox();
      await box.add(notification);
    }

    static Future<List<NotificationModel>> getAllNotifications() async {
      final box = await _openBox();
      return box.values.toList().reversed.toList(); // Newest first
    }

    static Future<void> markAsRead(String id) async {
      final box = await _openBox();
      final index = box.values.toList().indexWhere((n) => n.id == id);
      if (index != -1) {
        final notification = box.getAt(index)!;
        notification.isRead = true;
        await box.putAt(index, notification);
      }
    }

    static Future<void> markAllAsRead() async {
      final box = await _openBox();
      for (var i = 0; i < box.length; i++) {
        final notification = box.getAt(i)!;
        if (!notification.isRead) {
          notification.isRead = true;
          await box.putAt(i, notification);
        }
      }
    }

    static Future<void> clearAll() async {
      final box = await _openBox();
      await box.clear();
    }

    static Future<int> getUnreadCount() async {
      final box = await _openBox();
      return box.values.where((n) => !n.isRead).length;
    }
  }