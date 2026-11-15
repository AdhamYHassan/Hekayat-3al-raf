import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Extension on [BuildContext] to provide language-aware auto-directional icons.
/// Adapts instantly between Arabic (RTL) and English (LTR).
extension DirectionalIconsExtension on BuildContext {
  /// Whether current active locale is Arabic
  bool get isArabic => locale.languageCode == 'ar';

  /// CTA / Forward Action Arrow (e.g. Next step, explore button)
  /// Points Right (→) in Arabic (RTL), and Right (→) in English (LTR).
  IconData get forwardArrow => CupertinoIcons.arrow_right;

  /// Back Action Arrow (e.g. Navigation back button)
  /// Points Left (←) in Arabic (RTL), and Left (←) in English (LTR).
  IconData get backArrow => CupertinoIcons.arrow_left;

  /// Navigation Chevron for list items, cards, and Next buttons
  /// Points Right (>) in Arabic (التالي >), and Right (>) in English (Next >).
  IconData get forwardChevron => Icons.chevron_right_rounded;

  /// Back Chevron for headers and previous buttons
  /// Points Left (<) in Arabic (< السابق), and Left (<) in English (< Prev).
  IconData get backChevron => Icons.chevron_left_rounded;
}

