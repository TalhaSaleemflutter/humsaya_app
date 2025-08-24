import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class CustomInfoCard extends StatelessWidget {
  final String title;
  final String description;
  final String additionalText;
  final String trailingIconPath;
  final Color backgroundColor;
  final bool isSvg;

  const CustomInfoCard({
    Key? key,
    required this.title,
    required this.description,
    required this.additionalText,
    required this.trailingIconPath,
    this.backgroundColor = Colors.white,
    this.isSvg = false, // Determines if the image is SVG or PNG
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0.2,
      margin: EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Text Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ThemeHelper.getTabbarTextColor(context, false),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeHelper.getTabbarTextColor(context, false),
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        additionalText,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6), // Space between text and icon
                      Container(
                        height: 20, // Adjust size
                        width: 20, // Adjust size
                        decoration: BoxDecoration(
                          color:
                              Theme.of(
                                context,
                              ).primaryColor, // Use primary color
                          shape: BoxShape.circle, // Make it circular
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_forward, // Right arrow
                            size: 14, // Adjust icon size
                            color: Colors.white, // Icon color
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Trailing Icon
            isSvg
                ? SvgPicture.asset(trailingIconPath, height: 70, width: 70)
                : Image.asset(trailingIconPath, height: 90.h, width: 90.w),
          ],
        ),
      ),
    );
  }
}
