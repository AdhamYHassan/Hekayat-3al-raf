import 'package:flutter/services.dart';
import 'package:hekayat_3al_raf/core/helpers/digit_converter.dart';

/// A reusable [TextInputFormatter] that automatically converts Arabic-Indic and
/// Eastern Arabic numerals (٠-٩, ۰-۹) into standard Western numerals (0-9) in real time.
class ArabicToEnglishDigitsFormatter extends TextInputFormatter {
  const ArabicToEnglishDigitsFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final converted = DigitConverter.convertString(newValue.text);
    if (converted == newValue.text) {
      return newValue;
    }

    return newValue.copyWith(
      text: converted,
      selection: TextSelection.collapsed(offset: converted.length),
    );
  }
}

