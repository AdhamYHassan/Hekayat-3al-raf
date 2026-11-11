import 'package:flutter/material.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';

/// App Theme Configuration for "حكايات على الرف".
/// Configures warm heritage Light Theme and luxurious Burgundy Dark Theme.
/// Strictly under 150 lines.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: FontManager.ibmPlexSansArabic,
        scaffoldBackgroundColor: ColorManager.backgroundLight,
        colorScheme: const ColorScheme.light(
          primary: ColorManager.primary,
          secondary: ColorManager.gold,
          surface: ColorManager.surfaceLight,
          error: ColorManager.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: ColorManager.textLight,
        ),
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: FontManager.ibmPlexSansArabic,
              bodyColor: ColorManager.textLight,
              displayColor: ColorManager.primary,
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorManager.surfaceLight,
          foregroundColor: ColorManager.primary,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          centerTitle: true,
        ),
        cardTheme: const CardThemeData(
          color: ColorManager.cardLight,
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: FontManager.ibmPlexSansArabic,
        scaffoldBackgroundColor: ColorManager.backgroundDark,
        colorScheme: const ColorScheme.dark(
          primary: ColorManager.primary,
          secondary: ColorManager.gold,
          surface: ColorManager.surfaceDark,
          error: ColorManager.error,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: ColorManager.textDark,
        ),
        textTheme: ThemeData.dark().textTheme.apply(
              fontFamily: FontManager.ibmPlexSansArabic,
              bodyColor: ColorManager.textDark,
              displayColor: ColorManager.goldLight,
            ),
        appBarTheme: const AppBarTheme(
          backgroundColor: ColorManager.surfaceDark,
          foregroundColor: ColorManager.goldLight,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          centerTitle: true,
        ),
        cardTheme: const CardThemeData(
          color: ColorManager.cardDark,
          elevation: 0,
          margin: EdgeInsets.zero,
        ),
      );
}
