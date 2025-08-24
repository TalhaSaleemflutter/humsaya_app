import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:humsaya_app/firebase_options.dart';
import 'package:humsaya_app/models/ad_product_model.dart';
import 'package:humsaya_app/models/location_model.dart';
import 'package:humsaya_app/models/notification_model.dart';
import 'package:humsaya_app/models/user_model.dart';
import 'package:humsaya_app/providers/ad_provider.dart';
import 'package:humsaya_app/providers/auth_provider.dart';
import 'package:humsaya_app/providers/category_provider.dart';
import 'package:humsaya_app/providers/chat_provider.dart';
import 'package:humsaya_app/providers/notification_provider.dart';
import 'package:humsaya_app/shared/constants/app_name.dart';
import 'package:humsaya_app/shared/theme/theme.dart';
import 'package:humsaya_app/views/auth/splash_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //  SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("🔥 Firebase Initialized Successfully!");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  var appDocumentDirectory = await getApplicationDocumentsDirectory();
  var directory = Directory(
    '${appDocumentDirectory.path}/humsaya_app_database',
  );

  await directory.create(recursive: true);
  Hive.init(directory.path);

  // await Hive.deleteBoxFromDisk('userBox');
  // await Hive.deleteBoxFromDisk('adBox');

  print('Hive box "adBox" opened successfully.');
  Hive.registerAdapter(UserModelAdapter()); //typeID 0
  Hive.registerAdapter(AdModelAdapter()); //typeID 1
  Hive.registerAdapter(LocationModelAdapter());
  Hive.registerAdapter(NotificationModelAdapter());

  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  runApp(MyApp(analytics: analytics));
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('background notification : ${message.notification?.title.toString()}');
  // Handle background message
}

class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics;
  const MyApp({super.key, required this.analytics});
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<AdProvider>(create: (_) => AdProvider()),
        ChangeNotifierProvider<ChatProvider>(create: (_) => ChatProvider()),
        ChangeNotifierProvider<CategoryProvider>(
          create: (_) => CategoryProvider(),
        ),
        ChangeNotifierProvider<NotificationProvider>(
          create: (_) => NotificationProvider(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            home: child,
            routes: {},
          );
        },
        child: const SplashScreen(),
      ),
    );
  }
}
