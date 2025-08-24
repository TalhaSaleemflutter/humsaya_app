import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class CenteredTextBox extends StatelessWidget {
  String? hintText;
  bool showNumPad;
  final String heading;
  final Function(String) onTextEntered; 

  CenteredTextBox({
    super.key,
    this.hintText,
    this.showNumPad = false,
    required this.heading,
    required this.onTextEntered,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: Container(
          width: 300.w,
          decoration: BoxDecoration(
            color: ThemeHelper.getBackGroundColor(context),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
                child: Text(
                  heading,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ThemeHelper.getTabbarTextColor(context, false),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                child: TextField(
                  controller: textController,
                  keyboardType:
                      showNumPad
                          ? TextInputType.number
                          : TextInputType.multiline,

                  style: const TextStyle(fontSize: 16),
                  maxLines: 5, // Maximum height of the TextField for 5 lines
                  minLines: 1, // Minimum height of the TextField for 1 line
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    filled: true,
                    fillColor: ThemeHelper.getTextFieldBackGroundColor(
                      context,
                    ), // Background color
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0.4,
                        color: ThemeHelper.getFieldBorderColor(context),
                      ), // Border color when not focused
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ThemeHelper.getFieldBorderColor(context),
                        width: 0.4,
                      ), // Border color when focused
                    ),
                    hintText: hintText ?? 'Enter text ',
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Padding removed from the Column here
              Column(
                children: [
                  // Border on top of the OK and Cancel buttons

                  // Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8.sp),
                              ),
                              side: BorderSide(
                                color: Colors.grey.withOpacity(.2),
                              ),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: primary, fontSize: 16.sp),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            if (textController.text.isNotEmpty) {
                              onTextEntered(textController.text);
                            }

                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(8.r),
                              ),
                              side: BorderSide(
                                color: Colors.grey.withOpacity(.2),
                              ),
                            ),
                          ),
                          child: Text(
                            'OK',
                            style: TextStyle(color: primary, fontSize: 16.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
