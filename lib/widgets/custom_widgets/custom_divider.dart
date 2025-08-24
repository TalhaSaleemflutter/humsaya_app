import 'package:flutter/material.dart';
import 'package:humsaya_app/shared/theme/theme_helper.dart';

class CustomDivider extends StatelessWidget {
  final Color? color;
  final double? height;
  final double? width;
  final Axis direction; // horizontal or vertical

  const CustomDivider({
    super.key,
    this.color,
    this.height,
    this.width,
    this.direction = Axis.horizontal, // default to horizontal
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: direction == Axis.horizontal ? height ?? 1.0 : height ?? double.infinity,
      width: direction == Axis.vertical ? width ?? 1.0 : width ?? double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color ?? ThemeHelper.getBorderColor(context),
        ),
      ),
    );
  }
}

