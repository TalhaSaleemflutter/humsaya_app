import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:humsaya_app/main.dart';
import 'package:humsaya_app/models/notification_model.dart';
import 'package:humsaya_app/providers/notification_provider.dart';
import 'package:humsaya_app/views/home/push_notifications.dart';
import 'package:provider/provider.dart';

class NotificationService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // first funcation which is called
  void requestNotificationsPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      criticalAlert: true,
      carPlay: true,
      provisional: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted permisssion');
      ;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user granted provisional permisssion');
    } else {
      print('user denied permission');
    }
  }

  // 2nd function which is called
  void firebaseInit() {
      final provider =
          navigatorKey.currentContext?.read<NotificationProvider>();
    FirebaseMessaging.onMessage.listen((message) async {
      print('Notification received: ${message.notification?.title}');
      // Create notification model
      final notification = NotificationModel(
        id:
            message.messageId ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: message.notification?.title ?? 'New Notification',
        body: message.notification?.body ?? '',
        timestamp: DateTime.now(),
        isRead: false,
      );    
      provider?.addNotification(notification);
      // Show local notification
      if (Platform.isAndroid) {
        await initLocalNotifications();
        await showNotification(message);
      } else {
        await showNotification(message);
      }
    });
  }

  // 3rd funcation which is called
  Future<void> initLocalNotifications() async {
    var androidInitilizationSettings = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    var iosInitilizationSettings = const DarwinInitializationSettings();

    var initilizationSetting = InitializationSettings(
      android: androidInitilizationSettings,
      iOS: iosInitilizationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initilizationSetting,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          handleMessage(data);
        }
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(10000).toString(),
      'High Importance notification',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          channel.id.toString(),
          channel.name.toString(),
          channelDescription: 'Your channel description',
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
        );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    // Prepare payload with proper structure
    Map<String, dynamic> payload = {
      'id':
          message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'title': message.notification?.title,
      'body': message.notification?.body,
      'notification': {
        'title': message.notification?.title,
        'body': message.notification?.body,
      },
    };

    await _flutterLocalNotificationsPlugin.show(
      // this displays notification pop-up on screen
      0,
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: jsonEncode(payload),
    );
  }

  Future<String> getDeviceToken(BuildContext context) async {
    String? token = await messaging.getToken();
    print('FCM Token refreshed: $token');
    if (token != null) {
      // await updateFcmToken(token);
    }
    return token ?? '';
  }

  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print('refreshed');
    });
  }

  // 4rth funcation which is called
  void handleMessage(Map<String, dynamic> data) {
    // Create notification from data
    final notification = NotificationModel(
      id: data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title:
          data['notification']?['title'] ?? data['title'] ?? 'New Notification',
      body: data['notification']?['body'] ?? data['body'] ?? '',
      timestamp: DateTime.now(),
      isRead: false,
    );

    // Add to provider
    final provider = navigatorKey.currentContext?.read<NotificationProvider>();
    provider?.addNotification(notification);

    // Navigate to notifications screen
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => const PushNotifications()),
    );
  }

  
  static void setupInteractMessage() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleBackgroundMessage(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        _handleBackgroundMessage(message);
      }
    });
  }

  static void _handleBackgroundMessage(RemoteMessage message) {
    // Ensure we have a context to work with
    if (navigatorKey.currentContext == null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _handleBackgroundMessage(message);
      });
      return;
    }

    // Create notification from message
    final notification = NotificationModel(
      id: message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      timestamp: DateTime.now(),
      isRead: false,
    );

    // Add to provider
    final provider = navigatorKey.currentContext!.read<NotificationProvider>();
    provider.addNotification(notification);

    // Navigate to notifications screen
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const PushNotifications()),
      (route) => false,
    );
  }
}




// void handleMessage(BuildContext context, RemoteMessage message) {
  //   print('Handling message: ${message.data}');
  //if (message.data['type'] == 'msj') {
  //   print(
  //     'Navigating to PushNotificationScreen with id: ${message.data['id']}',
  //   );
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => PushNotifications(id: message.data['id']),
  //     ),
  //   );
    // Navigator.pushNamed(
    //   context,
    //   '/push_notifications',
    //   arguments: PushNotification(id: message.data['id']),
    // );
    //  }
  // }