import 'package:flutter/material.dart';

/// Centralized color palette matching the official "حكايات على الرف" design system.
///
/// Follows Single Responsibility Principle (SRP): purely defines brand color tokens
/// and theme-mode resolution helpers. Kept strictly under 150 lines.
class ColorManager {
  ColorManager._();

  // Primary Brand Colors (العنابي / الخمري التراثي والدرجات الدافئة)
  static const Color primary = Color(0xFF4A0F20);
  static const Color primaryDark = Color(0xFF220610);
  static const Color primaryDeep = Color(0xFF330A16);

  // Gold & Bronze Accent Colors (الذهب والبرونز)
  static const Color gold = Color(0xFFC9A24B);
  static const Color goldLight = Color(0xFFE8CB7D);
  static const Color goldDark = Color(0xFF9A7627);
  static const Color orange = gold; // Backward compatibility alias for secondary accent

  // Terracotta / Warm Accent (اللمسات الطينية الدافئة)
  static const Color terracotta = Color(0xFFA9533A);

  // Light Theme Neutrals (ورق قديم وخلفيات كريمية دافئة)
  static const Color backgroundLight = Color(0xFFFAF7F2);
  static const Color surfaceLight = Color(0xFFFFFDF8);
  static const Color cardLight = Color(0xFFFBF6EC);
  static const Color borderLight = Color(0xFFE4D8C6);
  static const Color textLight = Color(0xFF220610);
  static const Color textMutedLight = Color(0xFF513A44);

  // Dark Theme Neutrals (الأسود العنابي الفاخر)
  static const Color backgroundDark = Color(0xFF140308);
  static const Color surfaceDark = Color(0xFF220610);
  static const Color cardDark = Color(0xFF2E0914);
  static const Color borderDark = Color(0xFF4A0F20);
  static const Color textDark = Color(0xFFFFFDF8);
  static const Color textMutedDark = Color(0xFFE4D8C6);

  // Semantic Feedback Colors
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFC62828);
  static const Color warning = Color(0xFFF57F17);

  // Dynamic Theme Resolvers
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color getBackground(BuildContext context) =>
      isDark(context) ? backgroundDark : backgroundLight;

  static Color getSurface(BuildContext context) =>
      isDark(context) ? surfaceDark : surfaceLight;

  static Color getCard(BuildContext context) =>
      isDark(context) ? cardDark : cardLight;

  static Color getBorder(BuildContext context) =>
      isDark(context) ? borderDark : borderLight;

  static Color getText(BuildContext context) =>
      isDark(context) ? textDark : textLight;

  static Color getTextMuted(BuildContext context) =>
      isDark(context) ? textMutedDark : textMutedLight;
}
