import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LocalizedString extends Equatable {
  final Map<String, String> translations;

  const LocalizedString(this.translations);

  factory LocalizedString.fromJson(
    Map<String, dynamic> json,
    String keyPrefix,
  ) {
    final map = <String, String>{};

    // 1. Check for suffix keys (e.g. category_en, category_ar)
    json.forEach((key, value) {
      if (key.startsWith('${keyPrefix}_') && value is String) {
        final langCode = key.substring(keyPrefix.length + 1);
        map[langCode] = value;
      }
    });

    // 2. Smart Fallback: If the prefix itself is a key (e.g. "category": "Value")
    if (json.containsKey(keyPrefix) && json[keyPrefix] is String) {
      final fallbackValue = json[keyPrefix] as String;
      map['default'] = fallbackValue;

      // Also map to 'en' if 'en' doesn't exist yet
      map.putIfAbsent('en', () => fallbackValue);
    }

    return LocalizedString(map);
  }

  String getValue(BuildContext context) {
    final currentLang = context.locale.languageCode;
    // Tries active language -> Tries English -> Tries default fallback -> Empty string
    return translations[currentLang] ??
        translations['en'] ??
        translations['default'] ??
        '';
  }

  @override
  List<Object?> get props => [translations];
}
