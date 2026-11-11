import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_details_entity.dart';

/// Q&A and Community Interaction section for an ambassador profile.
/// Connected with endpoint: POST /ar/api/v1/mobile/ambassadors/{slug}/questions/
/// Payload: { "body": String }
class AmbassadorQaSection extends StatefulWidget {
  final List<AmbassadorQaItem> questions;
  final bool isSubmitting;
  final ValueChanged<String> onSubmitQuestion;

  const AmbassadorQaSection({
    super.key,
    required this.questions,
    required this.isSubmitting,
    required this.onSubmitQuestion,
  });

  @override
  State<AmbassadorQaSection> createState() => _AmbassadorQaSectionState();
}

class _AmbassadorQaSectionState extends State<AmbassadorQaSection> {
  final _questionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmitQuestion(_questionController.text.trim());
      _questionController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Text(
                'ambassadors.qa_title'.tr(),
                style: AppFonts.alexandria(
                  color: ColorManager.paper100,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '(${widget.questions.length})',
                style: AppFonts.ibmPlexSansArabic(
                  color: ColorManager.gold,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),

        // 1. Submit Question Form
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: ColorManager.primaryLight.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: ColorManager.gold.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ambassadors.ask_ambassador'.tr(),
                    style: AppFonts.alexandria(
                      color: ColorManager.goldLight,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8.h),
                  _FormField(
                    controller: _questionController,
                    hint: 'ambassadors.ask_hint'.tr(),
                    maxLines: 3,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'validation.required_field'.tr() : null,
                  ),
                  SizedBox(height: 10.h),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: ElevatedButton(
                      onPressed: widget.isSubmitting ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.gold,
                        foregroundColor: ColorManager.primaryDark,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      child: widget.isSubmitting
                          ? SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ColorManager.primaryDark,
                              ),
                            )
                          : Text(
                              'ambassadors.send_question'.tr(),
                              style: AppFonts.ibmPlexSansArabic(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: 16.h),

        // 2. Questions List
        ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.questions.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final item = widget.questions[index];
            return Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: ColorManager.primaryLight.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: ColorManager.gold.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.city.isNotEmpty
                            ? '${item.authorName} · ${item.city}'
                            : item.authorName,
                        style: AppFonts.ibmPlexSansArabic(
                          color: ColorManager.goldLight,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        item.timeAgo,
                        style: AppFonts.ibmPlexSansArabic(
                          color: ColorManager.paper400,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    item.question,
                    style: AppFonts.ibmPlexSansArabic(
                      color: ColorManager.paper100,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  if (item.answer != null) ...[
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: ColorManager.primaryDark.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border(
                          right: BorderSide(
                            color: ColorManager.gold,
                            width: 2.5.w,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ambassadors.ambassador_reply'.tr(),
                            style: AppFonts.ibmPlexSansArabic(
                              color: ColorManager.goldLight,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            item.answer!,
                            style: AppFonts.ibmPlexSansArabic(
                              color: ColorManager.paper200,
                              fontSize: 12.sp,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final String? Function(String?)? validator;

  const _FormField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: AppFonts.ibmPlexSansArabic(
        color: ColorManager.paper100,
        fontSize: 12.sp,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppFonts.ibmPlexSansArabic(
          color: ColorManager.paper400,
          fontSize: 11.sp,
        ),
        filled: true,
        fillColor: ColorManager.primaryDark.withValues(alpha: 0.5),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(
            color: ColorManager.gold.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(
            color: ColorManager.gold.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: const BorderSide(color: ColorManager.gold),
        ),
      ),
    );
  }
}
