import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:humsaya_app/shared/constants/app_textstyle.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';
import 'package:humsaya_app/widgets/custom_widgets/custom_button.dart';


class CustomKeyboard extends StatefulWidget {
  final ValueChanged<String> onKeyPressed;
  final VoidCallback onFinish;

  const CustomKeyboard({
    super.key,
    required this.onKeyPressed,
    required this.onFinish,
  });

  @override
  CustomKeyboardState createState() => CustomKeyboardState();
}

class CustomKeyboardState extends State<CustomKeyboard> {
  String _displayValue = '0';

  void _handleKeyPress(String key) {
    setState(() {
      if (key == '<') {
        if (_displayValue.length > 1) {
          _displayValue = _displayValue.substring(0, _displayValue.length - 1);
        } else {
          _displayValue = '0';
        }
      } else {
        if (_displayValue == '0') {
          _displayValue = key;
        } else {
          _displayValue += key;
        }
      }
    });
    widget.onKeyPressed(_displayValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$_displayValue \$',
          style: AppTextStyles.headText(context)
              .copyWith(fontWeight: FontWeight.w700, fontSize: 34.sp),
        ),
        SizedBox(
          height: 32.h,
        ),
        Container(
          padding: EdgeInsets.all(10.h),
          color: ThemeHelper.isDarkMode(context)
              ? cardColor.withOpacity(0.5)
              : grey2.withOpacity(0.3),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(3.w, 3.h, 3.w, 10.h),
                child: CustomButton(
                  bgColor: primary,
                  txtColor: white,
                  text: 'Finish',
                  onTap: widget.onFinish,
                ),
              ),
              _buildButtonRow(['1', '2', '3'], context),
              _buildButtonRow(['4', '5', '6'], context),
              _buildButtonRow(['7', '8', '9'], context),
              _buildButtonRow(['.', '0', '<'], context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtonRow(List<String> keys, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        return Expanded(
          child: GestureDetector(
            onTap: () => _handleKeyPress(key),
            child: Container(
              margin: EdgeInsets.all(3.h),
              height: 50.h,
              decoration: BoxDecoration(
                boxShadow: [
                  ThemeHelper.isDarkMode(context)
                      ? const BoxShadow()
                      : BoxShadow(
                          blurRadius: 10,
                          offset: Offset(0, 3.w),
                          color: grey1.withOpacity(0.5)),
                ],
                color: ThemeHelper.getFieldColor(context),
                borderRadius: BorderRadius.circular(8.r),
              ),
              alignment: Alignment.center,
              child: Text(
                key,
                style: AppTextStyles.headText(context)
                    .copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
