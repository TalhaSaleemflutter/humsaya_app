import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import '../theme/app_palette.dart';
import '../theme/theme_helper.dart';

class AppTextStyles {
  static TextStyle authHeadingText(BuildContext context) {
    return TextStyle(
      fontFamily: 'Mulish',
      color: ThemeHelper.getBlackWhite(context),
      fontSize: 22.sp,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle appBarHeadingText(BuildContext context) {
    return TextStyle(
      fontFamily: 'Mulish',
      color: ThemeHelper.getBlackWhite(context),
      fontSize: 20.sp,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle subHeadingText(BuildContext context) {
    return TextStyle(
      fontFamily: 'Mulish',
      color: ThemeHelper.getBorderColor(context),
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle headingGreenText(BuildContext context) {
    return TextStyle(
      fontFamily: 'Mulish',
      color: primary,
      height: 1.3.h,
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle bodyText1(BuildContext context) {
    return TextStyle(
      // fontFamily: 'Mulish',
      color: Theme.of(context).textTheme.bodyLarge?.color,
      fontWeight: FontWeight.normal,
      height: 1.3.h,
      fontSize: 12.sp,
    );
  }

  static TextStyle bodyText2(BuildContext context) {
    return TextStyle(
      // fontFamily: 'Mulish',
      color: Theme.of(context).textTheme.bodyLarge?.color,
      fontWeight: FontWeight.normal,
      height: 1.3.h,
      fontSize: 14.sp,
    );
  }

  static TextStyle bodyText3(BuildContext context) {
    return TextStyle(
      // fontFamily: 'Mulish',
      color: Theme.of(context).textTheme.bodyLarge?.color,
      fontWeight: FontWeight.normal,
      height: 1.3.h,
      fontSize: 16.sp,
    );
  }

  static TextStyle bodyText4(BuildContext context) {
    return TextStyle(
      // fontFamily: 'Mulish',
      color: Theme.of(context).textTheme.bodyLarge?.color,
      fontWeight: FontWeight.normal,
      height: 1.3.h,
      fontSize: 18.sp,
    );
  }

  static TextStyle bodyText4Bold(BuildContext context) {
    return TextStyle(
      // fontFamily: 'Mulish',
      color: Theme.of(context).textTheme.bodyLarge?.color,
      fontWeight: FontWeight.bold,
      height: 1.3.h,
      fontSize: 18.sp,
    );
  }

  static TextStyle bodyText5(BuildContext context) {
    return TextStyle(
      // fontFamily: 'Mulish',
      color: Theme.of(context).textTheme.bodyLarge?.color,
      fontWeight: FontWeight.normal,
      height: 1.3.h,
      fontSize: 20.sp,
    );
  }

  static TextStyle headText(BuildContext context) {
    return TextStyle(
      fontFamily: 'Mulish',
      color: Theme.of(context).textTheme.bodyLarge?.color,
      fontWeight: FontWeight.w500,
      height: 1.9.h,
      fontSize: 20.sp,
    );
  }

  static TextStyle fieldText(BuildContext context) {
    return TextStyle(
      fontFamily: 'Mulish',
      color: ThemeHelper.isDarkMode(context) ? white : grey2,
      fontWeight: FontWeight.w500,
      fontSize: 14.sp,
    );
  }
}
