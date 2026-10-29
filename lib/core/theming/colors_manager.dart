import 'package:flutter/material.dart';

class ColorManager {
  // Primary Color
  static const Color primary = Color(0xFFFF8AA0);
  static const Color orange = Color(0xFFFE7A01);

  //Light Theme
  static const Color backgroundLight = Color(0xFFF4F6F9);
  static const Color textLight = Color(0xFF1A202C);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE2E8F0);

  //Dark Theme
  static const Color backgroundDark = Color(0xFF0D151E);
  static const Color textDark = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF161F2A);
  static const Color borderDark = Color(0xFF2E3E52);

  // Login Card Gradient Colors
  static const Color cardGradientStart = Color(0xFF014B8E);
  static const Color cardGradientEnd = Color(0xFF001529);

  // Text Field Overlay Colors
  static const Color textFormFill = Color(0xFF161F2A); // ~8% opacity white
  static const Color textFormBorder = Color(0x3DFFFFFF); // ~24% opacity white

  // Helper getters
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color getBackground(BuildContext context) =>
      isDark(context) ? backgroundDark : backgroundLight;

  static Color getCard(BuildContext context) =>
      isDark(context) ? cardDark : cardLight;

  static Color getBorder(BuildContext context) =>
      isDark(context) ? borderDark : borderLight;

  static Color getText(BuildContext context) =>
      isDark(context) ? textDark : textLight;

  static Color getTextMuted(BuildContext context) =>
      isDark(context) ? Colors.white54 : Colors.black54;
}
