import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool _isLoggedIn = true;
  String? _guestNameError;
  String? _guestPhoneError;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SubmitStoryCubit>();
    _guestNameController = TextEditingController(text: cubit.state.guestName);
    _guestPhoneController = TextEditingController(text: cubit.state.guestPhone);
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final token = await SecureStorageHelper.getToken();
    if (mounted) {
      setState(() {
        _isLoggedIn = token != null && token.isNotEmpty;
      });
    }
  }

  bool _validateGuestFields() {
    if (_isLoggedIn) return true;

    bool isValid = true;
    if (_guestNameController.text.trim().isEmpty) {
      _guestNameError = 'validation.guest_name_required'.tr();
      isValid = false;
    } else {
      _guestNameError = null;
    }

    final phone = _guestPhoneController.text.trim();
    if (phone.isEmpty) {
      _guestPhoneError = 'validation.guest_phone_required'.tr();
      isValid = false;
    } else if (phone.length < 9) {
      _guestPhoneError = 'validation.invalid_phone'.tr();
      isValid = false;
    } else {
      _guestPhoneError = null;
    }

    setState(() {});
    return isValid;
  }

  @override
  void dispose() {
    _guestNameController.dispose();
    _guestPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SubmitStoryCubit>();

    return BlocConsumer<SubmitStoryCubit, SubmitStoryState>(
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
                  Icon(CupertinoIcons.checkmark_seal_fill, color: ColorManager.gold, size: 24.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'تم بنجاح',
                    style: GoogleFonts.alexandria(
                      color: ColorManager.paper100,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              content: Text(
                state.successMessage ?? 'تم إرسال حكايتك بنجاح ومراجعتها قريباً.',
                style: GoogleFonts.ibmPlexSansArabic(color: ColorManager.paper200, fontSize: 13.sp),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pop(); // Back to main submit screen
                    cubit.setStep(1);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: ColorManager.gold),
                  child: Text(
                    'common.ok'.tr(),
                    style: GoogleFonts.alexandria(color: ColorManager.primaryDark, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: ColorManager.error,
              content: Text(
                state.errorMessage!,
                style: GoogleFonts.ibmPlexSansArabic(color: Colors.white),
              ),
            ),
          );
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
                  border: Border.all(color: ColorManager.gold.withValues(alpha: 0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(CupertinoIcons.doc_text_fill, color: ColorManager.gold, size: 20.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            state.title.isNotEmpty ? state.title : 'عنوان غير محدد',
                            style: GoogleFonts.alexandria(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.paper100,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    _buildReviewItem('الكاتب / الراوي:', state.showAuthor ? state.authorName : 'بدون اسم (مخفي)'),
                    SizedBox(height: 6.h),
                    _buildReviewItem('نوع الحكاية:', _getFormatLabel(widget.format)),
                    SizedBox(height: 6.h),
                    _buildReviewItem('الوصف المختصر:', state.summary.isNotEmpty ? state.summary : '—'),
                    if (state.coverImagePath != null) ...[
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Icon(CupertinoIcons.photo, color: ColorManager.goldLight, size: 14.sp),
                          SizedBox(width: 6.w),
                          Text(
                            'صورة الغلاف مرفقة',
                            style: GoogleFonts.ibmPlexSansArabic(fontSize: 12.sp, color: ColorManager.goldLight),
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
                    border: Border.all(color: ColorManager.gold.withValues(alpha: 0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(CupertinoIcons.person_badge_plus, color: ColorManager.gold, size: 18.sp),
                          SizedBox(width: 6.w),
                          Text(
                            'بيانات الزائر (لربط الحكاية بحسابك لاحقاً)',
                            style: GoogleFonts.alexandria(
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
                        hint: 'اسمك الكامل',
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
                      _buildGuestTextField(
                        controller: _guestPhoneController,
                        hint: 'رقم الموبايل (مثال: 01012345678)',
                        icon: CupertinoIcons.phone,
                        keyboardType: TextInputType.phone,
                        errorMessage: _guestPhoneError,
                        onChanged: (val) {
                          cubit.updateGuestInfo(phone: val);
                          if (_guestPhoneError != null) {
                            setState(() => _guestPhoneError = null);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 24.h),

              // Actions: Previous + Submit
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () => cubit.setStep(2),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: ColorManager.paper100.withValues(alpha: 0.3)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                    ),
                    icon: Icon(Icons.chevron_right_rounded, color: ColorManager.paper100, size: 18.sp),
                    label: Text(
                      'submit.prev'.tr(),
                      style: GoogleFonts.ibmPlexSansArabic(
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
                              if (!_validateGuestFields()) {
                                return;
                              }
                              cubit.submitStory();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.gold,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
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
                          : Icon(CupertinoIcons.paperplane_fill, color: ColorManager.primaryDark, size: 18.sp),
                      label: Text(
                        state.isSubmitting ? 'جاري الإرسال...' : 'تأكيد وإرسال الحكاية',
                        style: GoogleFonts.alexandria(
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
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 12.sp,
            color: ColorManager.paper400,
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.ibmPlexSansArabic(
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
          onChanged: onChanged,
          style: GoogleFonts.ibmPlexSansArabic(fontSize: 13.sp, color: ColorManager.paper100),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: hasError ? ColorManager.error : ColorManager.goldLight,
              size: 16.sp,
            ),
            hintText: hint,
            hintStyle: GoogleFonts.ibmPlexSansArabic(
              fontSize: 12.sp,
              color: ColorManager.paper400.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: ColorManager.primaryDark,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: hasError ? ColorManager.error : ColorManager.gold.withValues(alpha: 0.2),
                width: hasError ? 1.2 : 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: hasError ? ColorManager.error : ColorManager.gold.withValues(alpha: 0.2),
                width: hasError ? 1.2 : 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: hasError ? ColorManager.error : ColorManager.gold.withValues(alpha: 0.4),
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
              style: GoogleFonts.ibmPlexSansArabic(
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
