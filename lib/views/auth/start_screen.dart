import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/views/auth/login_with_phone_screen.dart';
import 'package:humsaya_app/views/home/choose_category_screen.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_button.dart';

import '../../shared/constants/app_textstyle.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 24.w, right: 24.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 60.h),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.h, right: 2.h),
                    child: Image.asset(AppAssets.appLogo, height: 24.h),
                  ),
                  Text(
                    'amsaya.pk',
                    style: TextStyle(
                      color: primary,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 80.h),
              SizedBox(
                height: 240.h,
                width: 300.w,
                child: SvgPicture.asset(
                  AppAssets.onBoard, // Ensure the SVG path is correct
                ),
              ),
              SizedBox(height: 80.h),
              Text(
                "Let's",
                style: AppTextStyles.bodyText2(
                  context,
                ).copyWith(fontSize: 45.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                "get started",
                style: AppTextStyles.bodyText2(
                  context,
                ).copyWith(fontSize: 45.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              Text(
                "Everything starts from here",
                style: AppTextStyles.bodyText2(
                  context,
                ).copyWith(fontSize: 16.sp),
              ),
              SizedBox(height: 40.h),
              CustomButton(
                txtColor: white,
                bgColor: primary,
                text: 'Log In',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginWithPhoneScreen(),
                    ),
                  );
                },
              ),
              SizedBox(height: 15.h),
              CustomButton(
                txtColor: ThemeHelper.getTabbarTextColor(context, false),
                borderColor: primary,
                bgColor: ThemeHelper.getCardColor(context),
                text: 'Sign Up',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChooseCategoryScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
