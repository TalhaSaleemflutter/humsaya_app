import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class CustomAuthButton extends StatelessWidget {
  final String? img;
  final String? svgIcon;
  final IconData? icon;
  final VoidCallback onTap;
  final double iconSize;
  final Color? iconColor; // Default should be null

  const CustomAuthButton({
    super.key,
    this.img,
    this.svgIcon,
    this.icon,
    required this.onTap,
    this.iconSize = 24,
    this.iconColor, // Default is null, so it keeps original color
  }) : assert(
         img != null || svgIcon != null || icon != null,
         "Either 'img', 'svgIcon', or 'icon' must be provided.",
       );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 61.h,
        width: 61.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ThemeHelper.getCardColor(context),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              spreadRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: _buildIcon()), // No need for context
      ),
    );
  }

  Widget _buildIcon() {
    if (svgIcon != null) {
      return Padding(
        padding: EdgeInsets.all(10.h),
        child: SvgPicture.asset(
          svgIcon!,
          height: iconSize,
          colorFilter:
              iconColor != null
                  ? ColorFilter.mode(iconColor!, BlendMode.srcIn)
                  : null,
        ),
      );
    } else if (img != null) {
      return Padding(
        padding: EdgeInsets.all(10.h),
        child: Image.asset(
          img!,
          height: iconSize,
          color: iconColor, // If null, it keeps original color
        ),
      );
    } else if (icon != null) {
      return Icon(icon, size: iconSize, color: iconColor);
    } else {
      return const SizedBox();
    }
  }
}
