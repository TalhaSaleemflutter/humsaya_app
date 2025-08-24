import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/shared/constants/app_assets.dart';
import 'package:humsaya_app/shared/constants/app_name.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/shared/utlis/shared_prefrences.dart';
import 'package:humsaya_app/views/auth/login_screen.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_button.dart';

import '../../../../shared/theme/app_palette.dart';

class PermissionPage extends StatelessWidget {
  const PermissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 43.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Column(
              children: [
                Image.asset(AppAssets.Product1),
                Text(
                  appName,
                  style: AppTextStyles.headText(
                    context,
                  ).copyWith(fontSize: 30.sp),
                ),
              ],
            ),
            Column(
              children: [
                Text.rich(
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyText1(context),
                  TextSpan(
                    text: 'By pressing Accept, you agree to our ',
                    children: [
                      TextSpan(
                        text: 'terms & conditions ',
                        style: AppTextStyles.bodyText1(
                          context,
                        ).copyWith(color: primary),
                      ),
                      const TextSpan(text: 'and '),
                      TextSpan(
                        text: 'privacy policy',
                        style: AppTextStyles.bodyText1(
                          context,
                        ).copyWith(color: primary),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.6.h),
                CustomButton(
                  text: 'Accept',
                  bgColor: primary,
                  txtColor: white,
                  onTap: () {
                    SharedPreferenceHelper.saveBool('acceptpolicy', true);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 14.6.h),
                CustomButton(
                  text: 'Decline',
                  bgColor:
                      ThemeHelper.isDarkMode(context)
                          ? cardColor
                          : Colors.black12,
                  borderColor: primary,
                  txtColor: ThemeHelper.isDarkMode(context) ? white : black,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
