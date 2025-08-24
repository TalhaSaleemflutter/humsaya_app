import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title; // Make title nullable
  final Widget? leadingIcon;
  final Widget trailingIcon;
  final Color backgroundColor;
  final double appBarHeight;
  final TextStyle? textStyle;

  const CustomAppBar({
    super.key,
    this.title, // Now optional
    this.leadingIcon,
    required this.trailingIcon,
    this.backgroundColor = Colors.transparent,
    this.appBarHeight = kToolbarHeight,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          leadingIcon != null
              ? InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(height: 20, width: 20, child: leadingIcon),
              )
              : SizedBox.shrink(),
          leadingIcon != null ? SizedBox(width: 15.w) : SizedBox(width: 5.w),
          title != null
              ? Text(
                title!,
                style:
                    textStyle ??
                    TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: ThemeHelper.getTabbarTextColor(context, false),
                    ),
                textAlign: TextAlign.center,
              )
              : const SizedBox.shrink(),
          const Spacer(),
          trailingIcon,
        ],
      ),
      centerTitle: true,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}
