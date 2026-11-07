class DigitConverter {
  DigitConverter._();

  static const Map<String, String> _arabicToWestern = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
    '۰': '0',
    '۱': '1',
    '۲': '2',
    '۳': '3',
    '۴': '4',
    '۵': '5',
    '۶': '6',
    '۷': '7',
    '۸': '8',
    '۹': '9',
  };

  /// Converts Arabic-Indic/Eastern digits in a string to Western digits (0-9).
  static String convertString(String input) {
    if (input.isEmpty) return input;
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      buffer.write(_arabicToWestern[char] ?? char);
    }
    return buffer.toString();
  }

  /// Recursively normalizes string values and numbers inside maps and lists.
  static dynamic convertPayloadDigits(dynamic payload) {
    if (payload == null) return null;

    if (payload is String) {
      return convertString(payload);
    }

    if (payload is Map) {
      final convertedMap = <dynamic, dynamic>{};
      payload.forEach((key, value) {
        final convertedKey = key is String ? convertString(key) : key;
        convertedMap[convertedKey] = convertPayloadDigits(value);
      });
      return convertedMap;
    }

    if (payload is List) {
      return payload.map((item) => convertPayloadDigits(item)).toList();
    }

    return payload;
  }
}

