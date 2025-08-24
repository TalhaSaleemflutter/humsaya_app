import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class GenericDashboardWidgets {
  static Widget showMoreText(BuildContext context) {
    return Text(
      'Show more',
      style: AppTextStyles.bodyText2(
        context,
      ).copyWith(fontSize: 13.sp, color: primary),
    );
  }

  static Widget moreIcon(BuildContext context) {
    return Icon(
      Icons.more_horiz,
      size: 25.w,
      color: Theme.of(context).appBarTheme.foregroundColor,
    );
  }

  static Widget moreIconVertical(BuildContext context) {
    return Icon(
      Icons.more_vert,
      size: 25.w,
      color: Theme.of(context).appBarTheme.foregroundColor,
    );
  }

  static Widget searchBar(BuildContext context) {
    return TextField(
      cursorColor: ThemeHelper.isDarkMode(context) ? white : grey2,
      decoration: InputDecoration(
        filled: true,
        fillColor: ThemeHelper.getCardColor(context),
        contentPadding: EdgeInsets.all(5.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: ThemeHelper.isDarkMode(context) ? transparent : grey1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: ThemeHelper.isDarkMode(context) ? transparent : grey1,
          ),
        ),
        prefixIcon: const Icon(Icons.search, color: grey2),
        hintText: 'Search',
        hintStyle: AppTextStyles.fieldText(context).copyWith(color: grey2),
      ),
    );
  }
}
