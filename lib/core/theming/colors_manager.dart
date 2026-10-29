import 'package:flutter/material.dart';

/// Centralized color palette matching EXACTLY the prototype HTML/CSS.
class ColorManager {
  ColorManager._();

  // Primary Maroon Brands (bg-maroon-dark, bg-maroon, bg-maroon-mid)
  static const Color primaryDark = Color(0xFF220610); // #220610 bg-maroon-dark
  static const Color primary = Color(0xFF330A16);     // #330A16 bg-maroon-mid
  static const Color primaryLight = Color(0xFF4A0F20); // #4A0F20 bg-maroon

  // Gold Brands (text-gold, bg-gold, border-gold)
  static const Color gold = Color(0xFFC9A24B);         // #C9A24B gold
  static const Color goldLight = Color(0xFFE8CB7D);    // #E8CB7D text-gold-light
  static const Color goldDark = Color(0xFF9A7627);     // #9A7627 gold-dark
  static const Color orange = gold;                    // Alias

  // Paper / Text Colors from HTML (text-paper-100, text-paper-200, text-paper-400)
  static const Color paper100 = Color(0xFFFFFDF8);     // #FFFDF8 text-paper-100
  static const Color paper200 = Color(0xFFF3DFD6);     // #F3DFD6 text-paper-200
  static const Color paper400 = Color(0xFF9CA3AF);     // #9CA3AF text-paper-400

  // Compatibility aliases
  static const Color textLight = paper100;
  static const Color textDark = paper100;
  static const Color textMutedLight = paper400;
  static const Color textMutedDark = paper400;

  // Semantic
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFC62828);
  static const Color warning = Color(0xFFF57F17);

  // Backgrounds
  static const Color backgroundLight = Color(0xFF220610);
  static const Color backgroundDark = Color(0xFF220610);
  static const Color surfaceLight = Color(0xFF330A16);
  static const Color surfaceDark = Color(0xFF330A16);
  static const Color cardLight = Color(0xFF4A0F20);
  static const Color cardDark = Color(0xFF4A0F20);
  static const Color borderLight = Color(0x33C9A24B);  // border-gold/20
  static const Color borderDark = Color(0x33C9A24B);

  static bool isDark(BuildContext context) => true; // App design is deeply dark-themed

  static Color getBackground(BuildContext context) => backgroundDark;
  static Color getSurface(BuildContext context) => surfaceDark;
  static Color getCard(BuildContext context) => cardDark;
  static Color getBorder(BuildContext context) => borderDark;
  static Color getText(BuildContext context) => paper100;
  static Color getTextMuted(BuildContext context) => paper400;
}
