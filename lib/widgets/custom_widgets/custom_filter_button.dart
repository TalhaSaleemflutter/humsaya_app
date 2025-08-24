import 'package:flutter/material.dart';

class CustomFilterButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color borderColor;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const CustomFilterButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.borderColor,
    required this.textColor,
    required this.backgroundColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      
      onPressed: onPressed,
      icon: Icon(icon, color: textColor, size: 18),
      label: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}
