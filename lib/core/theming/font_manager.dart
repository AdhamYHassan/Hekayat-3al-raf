import 'package:flutter/material.dart';

/// Font families applied across "حكايات على الرف".
/// Extracted directly from the official typography system.
class FontManager {
  FontManager._();

  /// Primary modern Arabic sans-serif for body copy, buttons, and details.
  static const String ibmPlexSansArabic = 'IBMPlexSansArabic';

  /// Bold Arabic geometric font for section headings, titles, and nav labels.
  static const String alexandria = 'Alexandria';

  /// Traditional Calligraphic Arabic font for heritage quotes and hero brand titles.
  static const String arefRuqaa = 'ArefRuqaa';
}

/// Helper functions to construct local offline TextStyles with full parameter support.
class AppFonts {
  AppFonts._();

  static TextStyle ibmPlexSansArabic({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    double? wordSpacing,
    TextDecoration? decoration,
    Color? decorationColor,
    TextOverflow? overflow,
    FontStyle? fontStyle,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
  }) {
    return TextStyle(
      fontFamily: FontManager.ibmPlexSansArabic,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      decorationColor: decorationColor,
      overflow: overflow,
      fontStyle: fontStyle,
      foreground: foreground,
      background: background,
      shadows: shadows,
    );
  }

  static TextStyle alexandria({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    double? wordSpacing,
    TextDecoration? decoration,
    Color? decorationColor,
    TextOverflow? overflow,
    FontStyle? fontStyle,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
  }) {
    return TextStyle(
      fontFamily: FontManager.alexandria,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      decorationColor: decorationColor,
      overflow: overflow,
      fontStyle: fontStyle,
      foreground: foreground,
      background: background,
      shadows: shadows,
    );
  }

  static TextStyle arefRuqaa({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    double? wordSpacing,
    TextDecoration? decoration,
    Color? decorationColor,
    TextOverflow? overflow,
    FontStyle? fontStyle,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
  }) {
    return TextStyle(
      fontFamily: FontManager.arefRuqaa,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      decorationColor: decorationColor,
      overflow: overflow,
      fontStyle: fontStyle,
      foreground: foreground,
      background: background,
      shadows: shadows,
    );
  }
}

/// Font weights helper conforming to Clean Code standards.
class FontWeightHelper {
  FontWeightHelper._();

  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
}

