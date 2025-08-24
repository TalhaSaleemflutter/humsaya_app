import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool isObscureText;
  final TextEditingController? controller;
  final VoidCallback onTap;
  final Widget? suffixIcon;
  final Color? fillColor;
  final String? Function(String?)? validator; // Accept validator function
  final void Function(String)? onChanged;
  final bool? readOnly; // Add onChanged callback

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    required this.onTap,
    this.suffixIcon,
    this.fillColor,
    this.validator, 
    this.onChanged,
    this.readOnly, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.h,
      decoration: const BoxDecoration(),
      child: TextFormField(
        readOnly: readOnly ?? false,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        onTap: onTap,
        obscureText: isObscureText,
        controller: controller,
        onChanged: onChanged, 
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor ?? ThemeHelper.getFieldColor(context),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 18.h,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: ThemeHelper.getFieldBorderColor(context),
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(10.r),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(10.r),
          ),
          hintText: hintText,
          hintStyle: AppTextStyles.fieldText(context),
          suffixIcon: suffixIcon,
        ),
        validator: validator, // Use the validator passed from the parent
      ),
    );
  }
}
