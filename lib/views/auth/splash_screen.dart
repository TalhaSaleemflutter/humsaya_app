import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/database/hive/user_hive.dart';
import 'package:humsaya_app/models/user_model.dart';
import 'package:humsaya_app/providers/ad_provider.dart';
import 'package:humsaya_app/providers/auth_provider.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/services/notification_services.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/utlis/shared_prefrences.dart';
import 'package:humsaya_app/views/auth/login_with_phone_screen.dart';
import 'package:humsaya_app/views/auth/start_screen.dart';
import 'package:humsaya_app/views/home/choose_category_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = false;
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _initialize();
    _fetchData();
    Future.delayed(const Duration(seconds: 3), checkUserLoginStatus);
  }

  Future<void> _initialize() async {
    print('Initializing services...');

    // Initialize notification services
    notificationService.requestNotificationsPermission();
    notificationService.firebaseInit();
    notificationService
        .isTokenRefresh(); // ✅ Starts listening for future token refreshes
    await notificationService.getDeviceToken(
      context,
    ); // ✅ Gets current token now
    NotificationService.setupInteractMessage();

    print('Services initialized');
  }

  Future<void> _fetchData() async {
    await _loadUserData();
    await _fetchMyAds();
  }

  Future<void> _loadUserData() async {
    UserHiveStorage storage = UserHiveStorage();
    UserModel? user = await storage.getUserData();
    if (user != null) {
      print('Stored User Data: ${user.toMap()}');
    } else {
      print('No user data found.');
    }
  }

  Future<void> _fetchMyAds() async {
    final adProvider = Provider.of<AdProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });
    try {
      await adProvider.getMyAds(context, authProvider.currentUser.uid);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchData() async {
    final adProvider = Provider.of<AdProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await adProvider.fetchAndSetAds(
      context,
      authProvider.currentUser?.uid ?? '',
    );
  }

  Future<void> checkUserLoginStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    var user = await UserHiveStorage().getUserData();

    final checkPolicy = await SharedPreferenceHelper.getBool('acceptpolicy');
    print('---------------userid${user?.uid}');
    if (checkPolicy == true) {
      if (user != null && user.uid.isNotEmpty) {
        authProvider.setCurrentUser(user);
        await fetchData();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChooseCategoryScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginWithPhoneScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StartScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SvgPicture.asset(
              //   AppAssets.logo, // Ensure the SVG path is correct
              //   width: 150.w, // Adjust width using ScreenUtil
              //   height: 150.h, // Adjust height using ScreenUtil
              // ),
              Image.asset(AppAssets.logo3),
              SizedBox(height: 20.h),
              Text(
                'Humsaya.pk',
                style: TextStyle(
                  color: primary,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
