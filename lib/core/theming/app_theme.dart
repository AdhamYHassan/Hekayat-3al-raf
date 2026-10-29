import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';

/// App Theme Configuration for "حكايات على الرف".
/// Configures warm heritage Light Theme and luxurious Burgundy Dark Theme.
/// Strictly under 150 lines.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
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
        textTheme: GoogleFonts.ibmPlexSansArabicTextTheme(
          ThemeData.light().textTheme.copyWith(
                bodyLarge: const TextStyle(color: ColorManager.textLight),
                bodyMedium: const TextStyle(color: ColorManager.textLight),
                bodySmall: const TextStyle(color: ColorManager.textMutedLight),
                titleLarge: const TextStyle(color: ColorManager.primary),
                titleMedium: const TextStyle(color: ColorManager.primary),
              ),
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
        textTheme: GoogleFonts.ibmPlexSansArabicTextTheme(
          ThemeData.dark().textTheme.copyWith(
                bodyLarge: const TextStyle(color: ColorManager.textDark),
                bodyMedium: const TextStyle(color: ColorManager.textDark),
                bodySmall: const TextStyle(color: ColorManager.textMutedDark),
                titleLarge: const TextStyle(color: ColorManager.goldLight),
                titleMedium: const TextStyle(color: ColorManager.goldLight),
              ),
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
