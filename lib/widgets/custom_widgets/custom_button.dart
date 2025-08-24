import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color? bgColor;
  final Color? txtColor;
  final VoidCallback? onTap; // Make onTap nullable for disabled state
  final double? height;
  final double? fontSize;
  final Color? borderColor;
  final bool isEnabled; // Property for enabling/disabling the button
  final bool isLoading; // Property for showing a loading indicator

  const CustomButton({
    super.key,
    required this.text,
    this.bgColor,
    this.txtColor,
    this.onTap,
    this.height,
    this.fontSize,
    this.borderColor,
    this.isEnabled = true, // Default to enabled
    this.isLoading = false, // Default to not loading
  });

  @override
  Widget build(BuildContext context) {
    final buttonBgColor =
        isEnabled
            ? (bgColor ??
                Theme.of(context).primaryColor) // Default to primaryColor
            : Colors.grey.shade400; // Default grey color for disabled state

    final buttonTxtColor =
        isEnabled
            ? (txtColor ?? Colors.white) // Default text color for enabled state
            : Colors.grey.shade600; // Adjust text color when disabled

    return InkWell(
      onTap:
          isEnabled && !isLoading
              ? onTap
              : null, // Disable tap functionality when not enabled or loading
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: height ?? 50.h,
        decoration: BoxDecoration(
          color: buttonBgColor,
          border: Border.all(
            width: 0.9,
            color:
                isEnabled
                    ? (borderColor ?? buttonBgColor)
                    : Colors.grey.shade600, // Grey border for disabled state
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child:
            isLoading
                ? SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: CircularProgressIndicator(
                    color:
                        buttonTxtColor, // Use text color for the loading indicator
                    strokeWidth: 2,
                  ),
                )
                : Text(
                  textAlign: TextAlign.center,
                  text,
                  style: AppTextStyles.headText(context).copyWith(
                    color: buttonTxtColor,
                    fontSize: fontSize ?? 18.sp,
                  ),
                ),
      ),
    );
  }
}
