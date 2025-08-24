import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/database/hive/user_hive.dart';
import 'package:humsaya_app/models/user_model.dart';
import 'package:humsaya_app/providers/auth_provider.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/views/auth/select_location_screen.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_appbar.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_button.dart';
import 'package:provider/provider.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});
  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarHeight: 30.h,
        title: '',
        textStyle: const TextStyle(fontSize: 20),
        leadingIcon: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(
              AppAssets.icBack,
              height: 20.h,
              width: 20.w,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
          ),
        ),
        trailingIcon: const SizedBox(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Consumer<AuthProvider>(
            builder: (
              BuildContext context,
              AuthProvider authProvider,
              Widget? child,
            ) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 80.h),
                  SizedBox(
                    height: 240.h,
                    width: 300.w,
                    child: SvgPicture.asset(AppAssets.icHomeLocation),
                  ),
                  SizedBox(height: 70.h),
                  Text(
                    "Neighbour Selection",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.authHeadingText(context),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Select your location by entering it manually or by allowing access.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyText2(
                      context,
                    ).copyWith(fontSize: 16.sp),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    authProvider.currentAddress.toString(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyText2(
                      context,
                    ).copyWith(fontSize: 12.sp),
                  ),
                  SizedBox(height: 110.h),
                  CustomButton(
                    txtColor: white,
                    bgColor: primary,
                    text: 'Select Automatically',
                    onTap: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await authProvider.fetchCurrentLocationWithAddress();
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    isLoading: _isLoading,
                  ),
                  SizedBox(height: 15.h),
                  CustomButton(
                    txtColor: ThemeHelper.getTabbarTextColor(context, false),
                    borderColor: primary,
                    bgColor: ThemeHelper.getCardColor(context),
                    text: 'Select manually',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  SelectLocationScreen(isFullScreen: true),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
