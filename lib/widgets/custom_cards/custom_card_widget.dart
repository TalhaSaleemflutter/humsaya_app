import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class CustomCardWidget extends StatelessWidget {
  final String path;
  final String title;
  final String subtitle;
  final Color color;
  final bool isMore;
  final VoidCallback? onTap;
  final Widget? trailingIcon; // Trailing icon as Widget
  final String? trailingText; // Trailing text as String
  final String? additionalText; // Additional text as a parameter
  final String? additionalTextAccount;
  final Color? subTitleColor;
  final Color? trailingTextColor;
  final Color? additionalTextColor; // Color for the additional text
  final double? height;
  final Color? iconColor;
  final String? amount; // Add the amount argument

  const CustomCardWidget({
    super.key,
    required this.path,
    required this.title,
    required this.subtitle,
    required this.color,
    this.isMore = false, // Default value
    this.trailingIcon, // Optional trailing icon
    this.trailingText, // Optional trailing text
    this.onTap,
    this.subTitleColor,
    this.height,
    this.additionalText,
    this.additionalTextColor,
    this.trailingTextColor,
    this.iconColor,
    this.amount,
    this.additionalTextAccount, // Pass the amount argument
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        margin: EdgeInsets.only(bottom: 7.h),
        decoration: BoxDecoration(
          border: Border.all(color: ThemeHelper.getFieldBorderColor(context)),
          color:
              ThemeHelper.isDarkMode(context)
                  ? cardColor
                  : grey1.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Leading Icon Container
            Padding(
              padding: EdgeInsets.only(bottom: 25.h),
              child: Container(
                height: 60.h,
                width: 50.w,
                padding: EdgeInsets.all(10.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ThemeHelper.getFieldBorderColor(context),
                  ),
                  color: color,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child:
                    iconColor != null
                        ? SvgPicture.asset(path, color: iconColor)
                        : SvgPicture.asset(path),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title text
                  Text(
                    title,
                    style: AppTextStyles.bodyText2(
                      context,
                    ).copyWith(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.fieldText(context).copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color:
                          subTitleColor ??
                          ThemeHelper.getTabbarTextColor(context, false),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  if (additionalText != null && additionalTextAccount != null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          additionalText!,
                          style: AppTextStyles.fieldText(context).copyWith(
                            fontSize: 12.sp,
                            color: additionalTextColor ?? Colors.grey,
                          ),
                        ),
                        Text(
                          additionalTextAccount!,
                          style: AppTextStyles.fieldText(context).copyWith(
                            fontSize: 12.sp,
                            color: additionalTextColor ?? Colors.grey,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Trailing Widget (Text, Amount and Icon)
            if (isMore) ...[
              SizedBox(width: 12.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (trailingText != null)
                    Text(
                      trailingText!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color:
                            trailingTextColor ??
                            ThemeHelper.getTabbarTextColor(context, false),
                      ),
                    ),
                  SizedBox(height: 8.h),
                  if (amount != null) ...[
                    Text(
                      amount!,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: ThemeHelper.getTabbarTextColor(context, false),
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                  if (trailingIcon != null) ...[trailingIcon!],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
