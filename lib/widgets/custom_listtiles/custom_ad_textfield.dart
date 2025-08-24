import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class CustomAdTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Color? color;
  final Widget? trailing;
  final Color? hintTextColor;
  final Color? iconColor;
  final IconData? prefixIcon;
  final VoidCallback? onPrefixIconTap;
  final ValueChanged<String>? onChanged;
  final bool? readOnly;

  const CustomAdTextField({
    super.key,
    this.controller,
    this.hintText,
    this.color,
    this.trailing,
    this.hintTextColor,
    this.iconColor,
    this.prefixIcon,
    this.onPrefixIconTap,
    this.onChanged,
    this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      margin: EdgeInsets.only(bottom: 7.h),
      decoration: BoxDecoration(
        border: Border.all(color: ThemeHelper.getFieldBorderColor(context)),
        color: ThemeHelper.getCardColor(context),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          if (prefixIcon != null)
            GestureDetector(
              onTap: onPrefixIconTap,
              child: Container(
                height: 44.h,
                width: 44.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ThemeHelper.getFieldBorderColor(context),
                  ),
                  color: color,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(
                    prefixIcon,
                    color: iconColor ?? Colors.grey,
                    size: 24.sp,
                  ),
                ),
              ),
            ),
          if (prefixIcon != null) SizedBox(width: 10.w),

          Expanded(
            child: TextField(
              readOnly: readOnly ?? false,
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: hintTextColor ?? Colors.grey,
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(bottom: 12.h, left: 4.w),
              ),
              style: TextStyle(
                fontSize: 14.sp,
                color: ThemeHelper.getTabbarTextColor(context, false),
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
