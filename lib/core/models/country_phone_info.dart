import 'package:equatable/equatable.dart';

/// [CountryPhoneInfo] Value Object representing country dialing configuration
/// with localization support and strict per-country phone validation rules.
class CountryPhoneInfo extends Equatable {
  final String nameAr;
  final String nameEn;
  final String code; // ISO-2 alpha code (e.g. 'EG', 'SA')
  final String dialCode; // International dial prefix (e.g. '+20', '+966')
  final String flag; // Visual emoji flag
  final int minLength;
  final int maxLength;
  final RegExp validationPattern;
  final String exampleNumber;

  const CountryPhoneInfo({
    required this.nameAr,
    required this.nameEn,
    required this.code,
    required this.dialCode,
    required this.flag,
    required this.minLength,
    required this.maxLength,
    required this.validationPattern,
    required this.exampleNumber,
  });

  String localizedName(String langCode) => langCode == 'ar' ? nameAr : nameEn;

  /// Returns whether the provided national subscriber number is valid for this country.
  /// Automatically strips dial code prefix or leading zero if user pasted full international format.
  bool isValid(String rawNumber) {
    final clean = normalizeNumber(rawNumber);
    if (clean.length < minLength || clean.length > maxLength) {
      return false;
    }
    return validationPattern.hasMatch(clean);
  }

  /// Normalizes national subscriber number by stripping dial code, '+', or double zero if pasted.
  String normalizeNumber(String rawNumber) {
    var clean = rawNumber.replaceAll(RegExp(r'\D'), '');
    final dialDigits = dialCode.replaceAll('+', '');
    
    // If number starts with 00 + dialDigits (e.g., 002010... -> 10...)
    if (clean.startsWith('00$dialDigits')) {
      clean = clean.substring(2 + dialDigits.length);
    }
    // If number starts with dialDigits (e.g., 201012345678 -> 1012345678)
    else if (clean.startsWith(dialDigits) && clean.length > dialDigits.length + 6) {
      clean = clean.substring(dialDigits.length);
    }

    return clean;
  }

  /// Finds matching country if user pasted a number with a dial code (e.g. +966..., 00971..., +20...)
  static CountryPhoneInfo? findByLeadingDialCode(String rawInput) {
    final clean = rawInput.trim();
    if (!clean.startsWith('+') && !clean.startsWith('00')) return null;

    final digitsOnly = clean.replaceAll(RegExp(r'\D'), '');
    
    // Check supported countries sorted by longest dialCode first to prevent ambiguities (+971 before +97)
    final sorted = List<CountryPhoneInfo>.from(supportedCountries)
      ..sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));

    for (final country in sorted) {
      final dialDigits = country.dialCode.replaceAll('+', '');
      if (digitsOnly.startsWith(dialDigits) || digitsOnly.startsWith('00$dialDigits')) {
        return country;
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [code, dialCode, minLength, maxLength];

  /// The curated list of 22 supported countries matching exactly the platform requirements
  static final List<CountryPhoneInfo> supportedCountries = [
    CountryPhoneInfo(
      nameAr: 'مصر',
      nameEn: 'Egypt',
      code: 'EG',
      dialCode: '+20',
      flag: '🇪🇬',
      minLength: 10,
      maxLength: 11,
      // Egyptian numbers start with 10, 11, 12, or 15 (optionally preceded by leading 0)
      validationPattern: RegExp(r'^0?1[0125][0-9]{8}$'),
      exampleNumber: '1012345678',
    ),
    CountryPhoneInfo(
      nameAr: 'السعودية',
      nameEn: 'Saudi Arabia',
      code: 'SA',
      dialCode: '+966',
      flag: '🇸🇦',
      minLength: 9,
      maxLength: 10,
      // Saudi mobile numbers start with 5
      validationPattern: RegExp(r'^0?5[0-9]{8}$'),
      exampleNumber: '512345678',
    ),
    CountryPhoneInfo(
      nameAr: 'الإمارات',
      nameEn: 'United Arab Emirates',
      code: 'AE',
      dialCode: '+971',
      flag: '🇦🇪',
      minLength: 9,
      maxLength: 9,
      validationPattern: RegExp(r'^5[0-9]{8}$'),
      exampleNumber: '501234567',
    ),
    CountryPhoneInfo(
      nameAr: 'الكويت',
      nameEn: 'Kuwait',
      code: 'KW',
      dialCode: '+965',
      flag: '🇰🇼',
      minLength: 8,
      maxLength: 8,
      validationPattern: RegExp(r'^[569][0-9]{7}$'),
      exampleNumber: '51234567',
    ),
    CountryPhoneInfo(
      nameAr: 'قطر',
      nameEn: 'Qatar',
      code: 'QA',
      dialCode: '+974',
      flag: '🇶🇦',
      minLength: 8,
      maxLength: 8,
      validationPattern: RegExp(r'^[3567][0-9]{7}$'),
      exampleNumber: '33123456',
    ),
    CountryPhoneInfo(
      nameAr: 'البحرين',
      nameEn: 'Bahrain',
      code: 'BH',
      dialCode: '+973',
      flag: '🇧🇭',
      minLength: 8,
      maxLength: 8,
      validationPattern: RegExp(r'^[36][0-9]{7}$'),
      exampleNumber: '36123456',
    ),
    CountryPhoneInfo(
      nameAr: 'عُمان',
      nameEn: 'Oman',
      code: 'OM',
      dialCode: '+968',
      flag: '🇴🇲',
      minLength: 8,
      maxLength: 8,
      validationPattern: RegExp(r'^[79][0-9]{7}$'),
      exampleNumber: '91234567',
    ),
    CountryPhoneInfo(
      nameAr: 'الأردن',
      nameEn: 'Jordan',
      code: 'JO',
      dialCode: '+962',
      flag: '🇯🇴',
      minLength: 9,
      maxLength: 9,
      validationPattern: RegExp(r'^7[789][0-9]{7}$'),
      exampleNumber: '791234567',
    ),
    CountryPhoneInfo(
      nameAr: 'لبنان',
      nameEn: 'Lebanon',
      code: 'LB',
      dialCode: '+961',
      flag: '🇱🇧',
      minLength: 7,
      maxLength: 8,
      validationPattern: RegExp(r'^[1-9][0-9]{6,7}$'),
      exampleNumber: '71123456',
    ),
    CountryPhoneInfo(
      nameAr: 'العراق',
      nameEn: 'Iraq',
      code: 'IQ',
      dialCode: '+964',
      flag: '🇮🇶',
      minLength: 10,
      maxLength: 10,
      validationPattern: RegExp(r'^7[0-9]{9}$'),
      exampleNumber: '7701234567',
    ),
    CountryPhoneInfo(
      nameAr: 'سوريا',
      nameEn: 'Syria',
      code: 'SY',
      dialCode: '+963',
      flag: '🇸🇾',
      minLength: 9,
      maxLength: 9,
      validationPattern: RegExp(r'^9[0-9]{8}$'),
      exampleNumber: '944123456',
    ),
    CountryPhoneInfo(
      nameAr: 'فلسطين',
      nameEn: 'Palestine',
      code: 'PS',
      dialCode: '+970',
      flag: '🇵🇸',
      minLength: 9,
      maxLength: 9,
      validationPattern: RegExp(r'^5[69][0-9]{7}$'),
      exampleNumber: '599123456',
    ),
    CountryPhoneInfo(
      nameAr: 'اليمن',
      nameEn: 'Yemen',
      code: 'YE',
      dialCode: '+967',
      flag: '🇾🇪',
      minLength: 9,
      maxLength: 9,
      validationPattern: RegExp(r'^7[0-9]{8}$'),
      exampleNumber: '771234567',
    ),
    CountryPhoneInfo(
      nameAr: 'السودان',
      nameEn: 'Sudan',
      code: 'SD',
      dialCode: '+249',
      flag: '🇸🇩',
      minLength: 9,
      maxLength: 9,
      validationPattern: RegExp(r'^[19][0-9]{8}$'),
      exampleNumber: '912345678',
    ),
    CountryPhoneInfo(
      nameAr: 'ليبيا',
      nameEn: 'Libya',
      code: 'LY',
      dialCode: '+218',
      flag: '🇱🇾',
      minLength: 9,
      maxLength: 9,
      validationPattern: RegExp(r'^9[1-6][0-9]{7}$'),
      exampleNumber: '912345678',
    ),
    CountryPhoneInfo(
      nameAr: 'تونس',
      nameEn: 'Tunisia',
      code: 'TN',
      dialCode: '+216',
      flag: '🇹🇳',
      minLength: 8,
      maxLength: 8,
      validationPattern: RegExp(r'^[2459][0-9]{7}$'),
      exampleNumber: '98123456',
    ),
    CountryPhoneInfo(
      nameAr: 'الجزائر',
      nameEn: 'Algeria',
      code: 'DZ',
      dialCode: '+213',
      flag: '🇩🇿',
      minLength: 9,
      maxLength: 9,
      validationPattern: RegExp(r'^[567][0-9]{8}$'),
      exampleNumber: '551234567',
    ),
    CountryPhoneInfo(
      nameAr: 'المغرب',
      nameEn: 'Morocco',
      code: 'MA',
      dialCode: '+212',
      flag: '🇲🇦',
      minLength: 9,
      maxLength: 9,
      validationPattern: RegExp(r'^[67][0-9]{8}$'),
      exampleNumber: '612345678',
    ),
    CountryPhoneInfo(
      nameAr: 'تركيا',
      nameEn: 'Turkey',
      code: 'TR',
      dialCode: '+90',
      flag: '🇹🇷',
      minLength: 10,
      maxLength: 10,
      validationPattern: RegExp(r'^5[0-9]{9}$'),
      exampleNumber: '5321234567',
    ),
    CountryPhoneInfo(
      nameAr: 'المملكة المتحدة',
      nameEn: 'United Kingdom',
      code: 'GB',
      dialCode: '+44',
      flag: '🇬🇧',
      minLength: 10,
      maxLength: 10,
      validationPattern: RegExp(r'^7[0-9]{9}$'),
      exampleNumber: '7911123456',
    ),
    CountryPhoneInfo(
      nameAr: 'ألمانيا',
      nameEn: 'Germany',
      code: 'DE',
      dialCode: '+49',
      flag: '🇩🇪',
      minLength: 10,
      maxLength: 11,
      validationPattern: RegExp(r'^1[567][0-9]{8,9}$'),
      exampleNumber: '15123456789',
    ),
    CountryPhoneInfo(
      nameAr: 'فرنسا',
      nameEn: 'France',
      code: 'FR',
      dialCode: '+33',
      flag: '🇫🇷',
      minLength: 9,
      maxLength: 9,
      validationPattern: RegExp(r'^[67][0-9]{8}$'),
      exampleNumber: '612345678',
    ),
    CountryPhoneInfo(
      nameAr: 'إيطاليا',
      nameEn: 'Italy',
      code: 'IT',
      dialCode: '+39',
      flag: '🇮🇹',
      minLength: 10,
      maxLength: 10,
      validationPattern: RegExp(r'^3[0-9]{9}$'),
      exampleNumber: '3201234567',
    ),
    CountryPhoneInfo(
      nameAr: 'أمريكا / كندا',
      nameEn: 'USA / Canada',
      code: 'US',
      dialCode: '+1',
      flag: '🇺🇸',
      minLength: 10,
      maxLength: 10,
      validationPattern: RegExp(r'^[2-9][0-9]{9}$'),
      exampleNumber: '2025550143',
    ),
  ];

  static CountryPhoneInfo get defaultCountry => supportedCountries.first; // Egypt (+20)

  static CountryPhoneInfo findByCode(String code) {
    return supportedCountries.firstWhere(
      (c) => c.code.toUpperCase() == code.toUpperCase(),
      orElse: () => defaultCountry,
    );
  }
}

