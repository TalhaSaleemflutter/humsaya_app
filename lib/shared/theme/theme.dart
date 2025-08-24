import 'package:flutter/material.dart';
import 'package:humsaya_app/shared/theme/app_palette.dart';


class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: white,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: white,
      foregroundColor: black,
    ),
    iconTheme: const IconThemeData(color: primary),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: black),
      headlineMedium: TextStyle(color: black),
      bodyMedium: TextStyle(color: black),
      bodyLarge: TextStyle(color: black),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: black,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: black,
      foregroundColor: white,
    ),
    iconTheme: const IconThemeData(color: primary),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: white),
      headlineMedium: TextStyle(color: white),
      bodyMedium: TextStyle(color: white),
      bodyLarge: TextStyle(color: white),
    ),
  );
}
