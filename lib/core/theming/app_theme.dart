import 'package:flutter/material.dart';
import 'package:base_app/core/theming/colors_manager.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Cairo',
    scaffoldBackgroundColor: ColorManager.backgroundLight,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorManager.primary,
      brightness: Brightness.light,
      primary: ColorManager.primary,
      onPrimary: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: ColorManager.textLight, fontFamily: 'Cairo'),
      bodyMedium: TextStyle(color: ColorManager.textLight, fontFamily: 'Cairo'),
      bodySmall: TextStyle(color: ColorManager.textLight, fontFamily: 'Cairo'),
      titleLarge: TextStyle(color: ColorManager.textLight, fontFamily: 'Cairo'),
      titleMedium: TextStyle(color: ColorManager.textLight, fontFamily: 'Cairo'),
      titleSmall: TextStyle(color: ColorManager.textLight, fontFamily: 'Cairo'),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Cairo',
    scaffoldBackgroundColor: ColorManager.backgroundDark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorManager.primary,
      brightness: Brightness.dark,
      primary: ColorManager.primary,
      onPrimary: Colors.black,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: ColorManager.textDark, fontFamily: 'Cairo'),
      bodyMedium: TextStyle(color: ColorManager.textDark, fontFamily: 'Cairo'),
      bodySmall: TextStyle(color: ColorManager.textDark, fontFamily: 'Cairo'),
      titleLarge: TextStyle(color: ColorManager.textDark, fontFamily: 'Cairo'),
      titleMedium: TextStyle(color: ColorManager.textDark, fontFamily: 'Cairo'),
      titleSmall: TextStyle(color: ColorManager.textDark, fontFamily: 'Cairo'),
    ),
  );
}
