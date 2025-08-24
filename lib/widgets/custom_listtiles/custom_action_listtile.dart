import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class CustomActionListTile extends StatefulWidget {
  final String path;
  final String title;
  final String subtitle;
  final Color color;
  final bool initialToggleValue;
  final void Function(bool)? onTap; // Updated to accept a boolean

  const CustomActionListTile({
    super.key,
    required this.path,
    required this.title,
    required this.subtitle,
    required this.color,
    this.initialToggleValue = false,
    this.onTap,
  });

  @override
  State<CustomActionListTile> createState() => _CustomActionListTileState();
}

class _CustomActionListTileState extends State<CustomActionListTile> {
  late bool isToggled;

  @override
  void initState() {
    super.initState();
    isToggled = widget.initialToggleValue;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap?.call(isToggled), // Pass isToggled to onTap
      child: Container(
        height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          border: Border.all(color: ThemeHelper.getFieldBorderColor(context)),
          color: ThemeHelper.getCardColor(context),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            // Icon Container or SizedBox if path is empty
            widget.path.isEmpty
                ? SizedBox(height: 4.h, width: 4.w)
                : Container(
                  height: 44.h,
                  width: 44.w,
                  padding: EdgeInsets.all(10.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ThemeHelper.getFieldBorderColor(context),
                    ),
                    color: widget.color,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(widget.path),
                ),
            SizedBox(width: 10.w),
            // Title
            Text(widget.title, style: AppTextStyles.bodyText2(context)),
            const Spacer(),
            // Subtitle
            Expanded(
              child: Text(
                widget.subtitle,
                style: AppTextStyles.fieldText(
                  context,
                ).copyWith(fontSize: 12.sp),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 10.w),
            // Switch for toggling
            Switch(
              value: isToggled,
              onChanged: (value) {
                setState(() {
                  isToggled = value;
                });
                widget.onTap?.call(isToggled);
              },
              activeColor: Colors.green,
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
