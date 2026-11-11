import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/helpers/arabic_to_english_digits_formatter.dart';
import 'package:hekayat_3al_raf/core/models/country_phone_info.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';

/// Reusable and strictly validated phone input component with an integrated
/// country selector featuring high-fidelity flags, country names, dial codes,
/// and automated English digit normalization.
class AppPhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final CountryPhoneInfo selectedCountry;
  final ValueChanged<CountryPhoneInfo> onCountryChanged;
  final ValueChanged<String>? onChanged;
  final String? errorMessage;
  final bool enabled;

  const AppPhoneInputField({
    super.key,
    required this.controller,
    required this.selectedCountry,
    required this.onCountryChanged,
    this.onChanged,
    this.errorMessage,
    this.enabled = true,
  });

  void _showCountryPicker(BuildContext context) {
    showCountryPickerSheet(
      context: context,
      selectedCountry: selectedCountry,
      onSelected: onCountryChanged,
    );
  }

  void _handleTextChange(String value) {
    // If user enters/pastes '+' or leading dial code (e.g., +966..., +20...)
    if (value.startsWith('+') || value.startsWith('00')) {
      final detectedCountry = CountryPhoneInfo.findByLeadingDialCode(value);
      if (detectedCountry != null) {
        onCountryChanged(detectedCountry);
        final normalized = detectedCountry.normalizeNumber(value);
        controller.value = TextEditingValue(
          text: normalized,
          selection: TextSelection.collapsed(offset: normalized.length),
        );
        onChanged?.call(normalized);
        return;
      }
    }

    onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;
    final hasError = errorMessage != null && errorMessage!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: ColorManager.primaryLight.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: hasError
                  ? ColorManager.error
                  : ColorManager.gold.withValues(alpha: 0.15),
              width: hasError ? 1.4 : 1.0,
            ),
          ),
          child: Row(
            children: [
              // 1. Interactive Country Flag + Name + DialCode Picker
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: enabled ? () => _showCountryPicker(context) : null,
                  borderRadius: BorderRadius.horizontal(
                    right: lang == 'ar' ? Radius.circular(12.r) : Radius.zero,
                    left: lang != 'ar' ? Radius.circular(12.r) : Radius.zero,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 13.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        left: lang == 'ar'
                            ? BorderSide(
                                color:
                                    ColorManager.gold.withValues(alpha: 0.15),
                                width: 1,
                              )
                            : BorderSide.none,
                        right: lang != 'ar'
                            ? BorderSide(
                                color:
                                    ColorManager.gold.withValues(alpha: 0.15),
                                width: 1,
                              )
                            : BorderSide.none,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedCountry.flag,
                          style: TextStyle(fontSize: 18.sp),
                        ),
                        SizedBox(width: 6.w),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 86.w),
                          child: Text(
                            selectedCountry.localizedName(lang),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppFonts.ibmPlexSansArabic(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorManager.paper100,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '(${selectedCountry.dialCode})',
                          textDirection: TextDirection.ltr,
                          style: AppFonts.ibmPlexSansArabic(
                            fontSize: 11.sp,
                            color: ColorManager.gold,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          CupertinoIcons.chevron_down,
                          size: 12.sp,
                          color: ColorManager.paper400.withValues(alpha: 0.7),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 2. Phone Input Field
              Expanded(
                child: TextFormField(
                  controller: controller,
                  enabled: enabled,
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                  inputFormatters: [
                    ArabicToEnglishDigitsFormatter(),
                    FilteringTextInputFormatter.allow(RegExp(r'[\d+]')),
                    LengthLimitingTextInputFormatter(
                      selectedCountry.maxLength + 6,
                    ),
                  ],
                  onChanged: _handleTextChange,
                  style: AppFonts.ibmPlexSansArabic(
                    fontSize: 14.sp,
                    color: ColorManager.paper100,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: selectedCountry.exampleNumber,
                    hintTextDirection: TextDirection.ltr,
                    hintStyle: AppFonts.ibmPlexSansArabic(
                      fontSize: 13.sp,
                      color: ColorManager.paper400.withValues(alpha: 0.4),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 14.h,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 3. Error message display
        if (hasError)
          Padding(
            padding: EdgeInsets.only(top: 4.h, right: 6.w, left: 6.w),
            child: Text(
              errorMessage!,
              style: AppFonts.ibmPlexSansArabic(
                fontSize: 11.sp,
                color: ColorManager.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}

/// Global helper to show the Dark Glassmorphic country picker bottom sheet
void showCountryPickerSheet({
  required BuildContext context,
  required CountryPhoneInfo selectedCountry,
  required ValueChanged<CountryPhoneInfo> onSelected,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (bottomSheetContext) => _CountryPickerSheet(
      selectedCountry: selectedCountry,
      onSelected: (country) {
        Navigator.pop(bottomSheetContext);
        onSelected(country);
      },
    ),
  );
}

class _CountryPickerSheet extends StatefulWidget {
  final CountryPhoneInfo selectedCountry;
  final ValueChanged<CountryPhoneInfo> onSelected;

  const _CountryPickerSheet({
    required this.selectedCountry,
    required this.onSelected,
  });

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  late final TextEditingController _searchController;
  late List<CountryPhoneInfo> _filteredCountries;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredCountries = List.from(CountryPhoneInfo.supportedCountries);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final clean = query.trim().toLowerCase();
    setState(() {
      if (clean.isEmpty) {
        _filteredCountries = List.from(CountryPhoneInfo.supportedCountries);
      } else {
        _filteredCountries = CountryPhoneInfo.supportedCountries.where((c) {
          return c.nameAr.toLowerCase().contains(clean) ||
              c.nameEn.toLowerCase().contains(clean) ||
              c.dialCode.contains(clean) ||
              c.code.toLowerCase().contains(clean);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.locale.languageCode;

    return Container(
      constraints: BoxConstraints(maxHeight: 0.75.sh),
      decoration: BoxDecoration(
        color: ColorManager.primaryDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        border: Border(
          top: BorderSide(
            color: ColorManager.gold.withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Handle bar
            SizedBox(height: 10.h),
            Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: ColorManager.paper400.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 12.h),

            // Header Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lang == 'ar' ? 'اختر الدولة' : 'Select Country',
                    style: AppFonts.alexandria(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.paper100,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.xmark_circle_fill,
                      color: ColorManager.paper400,
                      size: 22.sp,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Search Box
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearch,
                style: AppFonts.ibmPlexSansArabic(
                  fontSize: 13.sp,
                  color: ColorManager.paper100,
                ),
                decoration: InputDecoration(
                  hintText: lang == 'ar'
                      ? 'ابحث باسم الدولة أو كود الاتصال...'
                      : 'Search by country or dial code...',
                  hintStyle: AppFonts.ibmPlexSansArabic(
                    fontSize: 12.sp,
                    color: ColorManager.paper400.withValues(alpha: 0.5),
                  ),
                  prefixIcon: Icon(
                    CupertinoIcons.search,
                    color: ColorManager.gold,
                    size: 18.sp,
                  ),
                  filled: true,
                  fillColor: ColorManager.primaryLight.withValues(alpha: 0.3),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(
                      color: ColorManager.gold.withValues(alpha: 0.2),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(
                      color: ColorManager.gold.withValues(alpha: 0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(
                      color: ColorManager.gold,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ),

            // Countries List
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                itemCount: _filteredCountries.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  color: ColorManager.paper400.withValues(alpha: 0.08),
                ),
                itemBuilder: (context, index) {
                  final country = _filteredCountries[index];
                  final isSelected = country.code == widget.selectedCountry.code;

                  return InkWell(
                    onTap: () => widget.onSelected(country),
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ColorManager.gold.withValues(alpha: 0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Text(
                            country.flag,
                            style: TextStyle(fontSize: 22.sp),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              country.localizedName(lang),
                              style: AppFonts.ibmPlexSansArabic(
                                fontSize: 13.5.sp,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                color: isSelected
                                    ? ColorManager.gold
                                    : ColorManager.paper100,
                              ),
                            ),
                          ),
                          Text(
                            '(${country.dialCode})',
                            textDirection: TextDirection.ltr,
                            style: AppFonts.ibmPlexSansArabic(
                              fontSize: 12.5.sp,
                              color: isSelected
                                  ? ColorManager.gold
                                  : ColorManager.paper400,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (isSelected) ...[
                            SizedBox(width: 10.w),
                            Icon(
                              CupertinoIcons.checkmark_alt,
                              color: ColorManager.gold,
                              size: 18.sp,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
