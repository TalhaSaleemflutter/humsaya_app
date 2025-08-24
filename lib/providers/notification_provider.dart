import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:humsaya_app/models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  int _unreadCount = 0;
  int get unreadCount => _unreadCount;

  NotificationProvider() {
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final box = await Hive.openBox<NotificationModel>('notifications');
    _notifications = box.values.toList();
    _unreadCount = _notifications.where((n) => !n.isRead).length;
    notifyListeners();
  }

  Future<void> addNotification(NotificationModel notification) async {
    final box = await Hive.openBox<NotificationModel>('notifications');
    await box.add(notification);

    _notifications.insert(0, notification);
    _unreadCount++;
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    final box = await Hive.openBox<NotificationModel>('notifications');
    final index = _notifications.indexWhere((n) => n.id == id);

    if (index != -1) {
      _notifications[index].isRead = true;
      await box.putAt(index, _notifications[index]);

      _unreadCount = _notifications.where((n) => !n.isRead).length;
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    final box = await Hive.openBox<NotificationModel>('notifications');

    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i].isRead = true;
        await box.putAt(i, _notifications[i]);
      }
    }

    _unreadCount = 0;
    notifyListeners();
  }

  Future<void> clearNotifications() async {
    final box = await Hive.openBox<NotificationModel>('notifications');
    await box.clear();

    _notifications = [];
    _unreadCount = 0;
    notifyListeners();
  }
}
