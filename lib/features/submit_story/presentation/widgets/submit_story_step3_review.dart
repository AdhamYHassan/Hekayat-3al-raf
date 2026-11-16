import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hekayat_3al_raf/core/helpers/direction_extension.dart';
import 'package:hekayat_3al_raf/core/routing/routes.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/helpers/arabic_to_english_digits_formatter.dart';
import 'package:hekayat_3al_raf/core/models/country_phone_info.dart';
import 'package:hekayat_3al_raf/core/widgets/app_phone_input_field.dart';
import 'package:hekayat_3al_raf/core/widgets/app_snack_bar.dart';
import 'package:hekayat_3al_raf/core/helpers/secure_storage_helper.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_entities.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/bloc/submit_story_cubit.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/bloc/submit_story_state.dart';

class SubmitStoryStep3Review extends StatefulWidget {
  final StorySubmissionFormat format;

  const SubmitStoryStep3Review({super.key, required this.format});

  @override
  State<SubmitStoryStep3Review> createState() => _SubmitStoryStep3ReviewState();
}

class _SubmitStoryStep3ReviewState extends State<SubmitStoryStep3Review> {
  late final TextEditingController _guestNameController;
  late final TextEditingController _guestPhoneController;
  late final TapGestureRecognizer _termsRecognizer;
  late CountryPhoneInfo _selectedCountry;
  bool _isLoggedIn = true;
  bool _agreedToTerms = false;
  String? _guestNameError;
  String? _guestPhoneError;
  String? _termsError;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SubmitStoryCubit>();
    _guestNameController = TextEditingController(text: cubit.state.guestName);
    _guestPhoneController = TextEditingController(text: cubit.state.guestPhone);

    _termsRecognizer = TapGestureRecognizer()..onTap = _navigateToTerms;

    final regionCode = cubit.state.guestPhoneRegion;
    _selectedCountry = CountryPhoneInfo.supportedCountries.firstWhere(
      (c) => c.code.toUpperCase() == regionCode.toUpperCase(),
      orElse: () => CountryPhoneInfo.supportedCountries.first,
    );

    _checkAuthStatus();
  }

  void _navigateToTerms() {
    final lang = context.locale.languageCode == 'en' ? 'en' : 'ar';
    context.push(
      Routes.webView,
      extra: {
        'title': 'settings.terms_conditions'.tr(),
        'url': 'https://hekayat3alraf.com/$lang/terms/',
      },
    );
  }

  Future<void> _checkAuthStatus() async {
    final token = await SecureStorageHelper.getToken();
    if (mounted) {
      setState(() {
        _isLoggedIn = token != null && token.isNotEmpty;
      });
    }
  }

  bool _validateForm() {
    bool isValid = true;

    if (!_isLoggedIn) {
      if (_guestNameController.text.trim().isEmpty) {
        _guestNameError = 'validation.guest_name_required'.tr();
        isValid = false;
      } else {
        _guestNameError = null;
      }

      final phone = _guestPhoneController.text.trim();
      final isArabic = context.locale.languageCode == 'ar';
      if (phone.isEmpty) {
        _guestPhoneError = 'validation.guest_phone_required'.tr();
        isValid = false;
      } else if (!_selectedCountry.isValid(phone)) {
        final countryName =
            isArabic ? _selectedCountry.nameAr : _selectedCountry.nameEn;
        _guestPhoneError = 'auth.invalid_phone_for_country'.tr(args: [
          countryName,
          _selectedCountry.exampleNumber,
        ]);
        isValid = false;
      } else {
        _guestPhoneError = null;
      }
    }

    if (!_agreedToTerms) {
      _termsError = 'submit.step3.terms_required'.tr();
      isValid = false;
    } else {
      _termsError = null;
    }

    setState(() {});
    return isValid;
  }

  @override
  void dispose() {
    _termsRecognizer.dispose();
    _guestNameController.dispose();
    _guestPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SubmitStoryCubit>();

    return BlocConsumer<SubmitStoryCubit, SubmitStoryState>(
      listenWhen: (previous, current) =>
          previous.isSubmittedSuccessfully != current.isSubmittedSuccessfully ||
          (current.errorMessage != null &&
              previous.errorMessage != current.errorMessage),
      listener: (context, state) {
        if (state.isSubmittedSuccessfully) {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              backgroundColor: ColorManager.primaryDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
                side: BorderSide(color: ColorManager.gold, width: 1.5),
              ),
              title: Row(
                children: [
                  Icon(
                    CupertinoIcons.checkmark_seal_fill,
                    color: ColorManager.gold,
                    size: 24.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'تم بنجاح',
                    style: AppFonts.alexandria(
                      color: ColorManager.paper100,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              content: Text(
                state.successMessage ??
                    'تم إرسال حكايتك بنجاح ومراجعتها قريباً.',
                style: AppFonts.ibmPlexSansArabic(
                  color: ColorManager.paper200,
                  fontSize: 13.sp,
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    cubit.resetForm();
                    Navigator.of(ctx, rootNavigator: true).pop();
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.gold,
                  ),
                  child: Text(
                    'common.ok'.tr(),
                    style: AppFonts.alexandria(
                      color: ColorManager.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (state.errorMessage != null) {
          AppSnackBar.showError(context, message: state.errorMessage!);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Review Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: ColorManager.primaryLight.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: ColorManager.gold.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.doc_text_fill,
                          color: ColorManager.gold,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            state.title.isNotEmpty
                                ? state.title
                                : 'submit.step3.unspecified_title'.tr(),
                            style: AppFonts.alexandria(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.paper100,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    _buildReviewItem(
                      'submit.step3.author_narrator'.tr(),
                      state.showAuthor
                          ? state.authorName
                          : 'submit.step3.anonymous_author'.tr(),
                    ),
                    SizedBox(height: 6.h),
                    _buildReviewItem(
                      'submit.step3.story_type'.tr(),
                      _getFormatLabel(widget.format),
                    ),
                    SizedBox(height: 6.h),
                    _buildReviewItem(
                      'submit.step3.summary'.tr(),
                      state.summary.isNotEmpty ? state.summary : '—',
                    ),
                    if (state.coverImagePath != null) ...[
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.photo,
                            color: ColorManager.goldLight,
                            size: 14.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'submit.step3.cover_attached'.tr(),
                            style: AppFonts.ibmPlexSansArabic(
                              fontSize: 12.sp,
                              color: ColorManager.goldLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Guest Fields Section (when no token)
              if (!_isLoggedIn) ...[
                SizedBox(height: 18.h),
                Container(
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: ColorManager.gold.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: ColorManager.gold.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.person_badge_plus,
                            color: ColorManager.gold,
                            size: 18.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'submit.step3.guest_info_title'.tr(),
                            style: AppFonts.alexandria(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.gold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      _buildGuestTextField(
                        controller: _guestNameController,
                        hint: 'submit.step3.guest_name_hint'.tr(),
                        icon: CupertinoIcons.person,
                        errorMessage: _guestNameError,
                        onChanged: (val) {
                          cubit.updateGuestInfo(name: val);
                          if (_guestNameError != null) {
                            setState(() => _guestNameError = null);
                          }
                        },
                      ),
                      SizedBox(height: 10.h),
                      AppPhoneInputField(
                        controller: _guestPhoneController,
                        selectedCountry: _selectedCountry,
                        errorMessage: _guestPhoneError,
                        onCountryChanged: (country) {
                          setState(() {
                            _selectedCountry = country;
                            _guestPhoneError = null;
                          });
                          cubit.updateGuestInfo(
                            phone: _guestPhoneController.text,
                            region: country.code,
                          );
                        },
                        onChanged: (val) {
                          cubit.updateGuestInfo(
                            phone: val,
                            region: _selectedCountry.code,
                          );
                          if (_guestPhoneError != null) {
                            setState(() => _guestPhoneError = null);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 18.h),

              // Accept Terms and Conditions Checkbox
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.primaryLight.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: _termsError != null
                        ? ColorManager.error
                        : ColorManager.gold.withValues(alpha: 0.12),
                    width: _termsError != null ? 1.4 : 1.0,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: Checkbox(
                          value: _agreedToTerms,
                          activeColor: ColorManager.gold,
                          checkColor: ColorManager.primaryDark,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          onChanged: (val) {
                            final checked = val ?? false;
                            setState(() {
                              _agreedToTerms = checked;
                              if (_agreedToTerms) {
                                _termsError = null;
                              }
                            });
                            cubit.updateAcceptTerms(checked);
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'submit.step3.agree_to_terms_prefix'.tr(),
                          style: AppFonts.ibmPlexSansArabic(
                            fontSize: 12.sp,
                            color: ColorManager.paper200.withValues(alpha: 0.8),
                          ),
                          children: [
                            TextSpan(
                              text: 'settings.terms_conditions'.tr(),
                              recognizer: _termsRecognizer,
                              style: AppFonts.ibmPlexSansArabic(
                                color: ColorManager.goldLight,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: ColorManager.goldLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_termsError != null)
                Padding(
                  padding: EdgeInsets.only(top: 6.h, right: 6.w, left: 6.w),
                  child: Text(
                    _termsError!,
                    style: AppFonts.ibmPlexSansArabic(
                      color: ColorManager.error,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              SizedBox(height: 20.h),

              // Actions: Previous + Submit
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => cubit.setStep(2),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: ColorManager.paper100.withValues(alpha: 0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 12.h,
                      ),
                    ),
                    icon: Icon(
                      context.backChevron,
                      color: ColorManager.paper100,
                      size: 18.sp,
                    ),
                    label: Text(
                      'submit.prev'.tr(),
                      style: AppFonts.ibmPlexSansArabic(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorManager.paper100,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: state.isSubmitting
                          ? null
                          : () {
                              if (!_validateForm()) {
                                return;
                              }
                              cubit.submitStory();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.gold,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        elevation: 0,
                      ),
                      icon: state.isSubmitting
                          ? SizedBox(
                              width: 18.r,
                              height: 18.r,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ColorManager.primaryDark,
                              ),
                            )
                          : Icon(
                              CupertinoIcons.paperplane_fill,
                              color: ColorManager.primaryDark,
                              size: 18.sp,
                            ),
                      label: Text(
                        state.isSubmitting
                            ? 'submit.step3.submitting'.tr()
                            : 'submit.step3.confirm_and_submit'.tr(),
                        style: AppFonts.alexandria(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.primaryDark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewItem(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.ibmPlexSansArabic(
            fontSize: 12.sp,
            color: ColorManager.paper400,
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            value,
            style: AppFonts.ibmPlexSansArabic(
              fontSize: 12.sp,
              color: ColorManager.paper100,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? errorMessage,
    required ValueChanged<String> onChanged,
  }) {
    final hasError = errorMessage != null && errorMessage.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: [
            if (keyboardType == TextInputType.phone ||
                keyboardType == TextInputType.number)
              const ArabicToEnglishDigitsFormatter(),
          ],
          onChanged: onChanged,
          style: AppFonts.ibmPlexSansArabic(
            fontSize: 13.sp,
            color: ColorManager.paper100,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: hasError ? ColorManager.error : ColorManager.goldLight,
              size: 16.sp,
            ),
            hintText: hint,
            hintStyle: AppFonts.ibmPlexSansArabic(
              fontSize: 12.sp,
              color: ColorManager.paper400.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: ColorManager.primaryDark,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: hasError
                    ? ColorManager.error
                    : ColorManager.gold.withValues(alpha: 0.2),
                width: hasError ? 1.2 : 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: hasError
                    ? ColorManager.error
                    : ColorManager.gold.withValues(alpha: 0.2),
                width: hasError ? 1.2 : 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: hasError
                    ? ColorManager.error
                    : ColorManager.gold.withValues(alpha: 0.4),
                width: hasError ? 1.5 : 1.0,
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(top: 4.h, right: 4.w, left: 4.w),
            child: Text(
              errorMessage,
              style: AppFonts.ibmPlexSansArabic(
                color: ColorManager.error,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  String _getFormatLabel(StorySubmissionFormat format) {
    return switch (format) {
      StorySubmissionFormat.written => 'submit.types.written'.tr(),
      StorySubmissionFormat.audio => 'submit.types.audio'.tr(),
      StorySubmissionFormat.video => 'submit.types.video'.tr(),
      StorySubmissionFormat.document => 'submit.types.document'.tr(),
    };
  }
}
