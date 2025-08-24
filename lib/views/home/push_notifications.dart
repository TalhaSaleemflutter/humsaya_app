import 'package:flutter/material.dart';
import 'package:humsaya_app/providers/notification_provider.dart';
import 'package:provider/provider.dart';

// push_notifications.dart
class PushNotifications extends StatelessWidget {
  const PushNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_as_unread),
            onPressed: provider.markAllAsRead,
          ),
        ],
      ),
      body:
          provider.notifications.isEmpty
              ? const Center(child: Text('No notifications yet'))
              : ListView.builder(
                itemCount: provider.notifications.length,
                itemBuilder: (context, index) {
                  final notification = provider.notifications[index];
                  return ListTile(
                    leading: Icon(
                      Icons.notifications,
                      color:
                          notification.isRead
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                    ),
                    title: Text(notification.title),
                    subtitle: Text(notification.body),
                    trailing: Text(
                      '${notification.timestamp.hour}:${notification.timestamp.minute}',
                      style: TextStyle(
                        color: notification.isRead ? Colors.grey : Colors.black,
                      ),
                    ),
                    onTap: () {
                      if (!notification.isRead) {
                        provider.markAsRead(notification.id);
                      }
                      // Handle notification tap
                    },
                  );
                },
              ),
    );
  }
}
