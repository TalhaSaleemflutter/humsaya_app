import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomRow extends StatelessWidget {
  final String title;
  final String value;
  final Color backgroundColor;
  final bool isUrl; // New parameter to determine if the value is a URL

  const CustomRow({
    Key? key,
    required this.title,
    required this.value,
    required this.backgroundColor,
    this.isUrl = false, // Default to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140.w,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child:
                isUrl
                    ? GestureDetector(
                      onTap: () async {
                        // Launch the URL when tapped
                        final Uri url = Uri.parse(value);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Could not launch $url')),
                          );
                        }
                      },
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        textAlign: TextAlign.left,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    )
                    : Text(
                      value,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
          ),
        ],
      ),
    );
  }
}