import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class CustomListTile extends StatelessWidget {
  final String path;
  final String title;
  final String subtitle;
  final Color color;
  final bool isMore;
  final VoidCallback? onTap;
  final Widget? trailing; // Updated to accept any Widget
  final Color? subTitleColor;
  final Color? iconColor;
  final IconData? dataIcon;
  final VoidCallback? onIconTap;
  final double iconSize; // New parameter for icon size

  const CustomListTile({
    super.key,
    required this.path,
    required this.title,
    required this.subtitle,
    required this.color,
    this.isMore = false,
    this.onTap,
    this.trailing,
    this.subTitleColor,
    this.iconColor,
    this.dataIcon,
    this.onIconTap,
    this.iconSize = 22.0, // Default size set to 22
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
            // Show icon only if path or dataIcon is provided
            if (path.isNotEmpty || dataIcon != null)
              Container(
                height: 44.h,
                width: 44.w,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ThemeHelper.getFieldBorderColor(context),
                  ),
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Center(child: _buildIconOrDefault()),
              )
            else
              SizedBox(width: 5.w),

            if (path.isNotEmpty || dataIcon != null) SizedBox(width: 10.w),

            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyText2(
                  context,
                ).copyWith(fontSize: 14.sp),
              ),
            ),
            Row(
              children: [
                Text(
                  subtitle,
                  style: AppTextStyles.fieldText(
                    context,
                  ).copyWith(fontSize: 13.sp, color: subTitleColor),
                ),
                if (isMore)
                  Row(
                    children: [
                      SizedBox(width: 12.w),
                      _resolveTrailing(trailing), // Resolve trailing
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// This method ensures both SVG and Icon are properly aligned inside the container.
  Widget _buildIconOrDefault() {
    if (path.isNotEmpty) {
      // Render SVG icon
      return SvgPicture.asset(
        path,
        color: iconColor,
        width: iconSize.w,
        height: iconSize.h,
        fit: BoxFit.contain,
      );
    } else if (dataIcon != null) {
      // Render default dataIcon
      return GestureDetector(
        onTap: onIconTap,
        child: Icon(
          dataIcon,
          color: iconColor ?? Colors.grey,
          size: iconSize.sp,
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

Widget _resolveTrailing(dynamic trailing) {
  if (trailing is String) {
    // Handle SVG or PNG assets
    if (trailing.endsWith('.svg')) {
      return SvgPicture.asset(
        trailing,
        color: iconColor,
        width: 22.w,
        height: 22.h,
        fit: BoxFit.contain,
      );
    } else if (trailing.endsWith('.png')) {
      return Image.asset(
        trailing,
        width: 22.w,
        height: 22.h,
        fit: BoxFit.contain,
      );
    }
  } else if (trailing is Widget) {
    return trailing;
  }
  return const SizedBox.shrink(); // Default fallback
}
