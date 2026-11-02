import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_entities.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/bloc/submit_story_cubit.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/bloc/submit_story_state.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/widgets/long_form_story_editor_field.dart';

/// [SubmitStoryStep2Form] renders the exact responsive HTML/Tailwind form layout:
/// - Written: Title, Author, Summary, Write Story (multi-line), Cover Image, Anonymous checkbox.
/// - Video/Document: Title, Author, Summary, "ارفع الملف" button with status indicator, Cover Image, Anonymous.
/// - Audio: Title, Author, Summary, Native 30-min long recording card with timer and waveform controls.
class SubmitStoryStep2Form extends StatefulWidget {
  final StorySubmissionFormat format;

  const SubmitStoryStep2Form({
    super.key,
    required this.format,
  });

  @override
  State<SubmitStoryStep2Form> createState() => _SubmitStoryStep2FormState();
}

class _SubmitStoryStep2FormState extends State<SubmitStoryStep2Form> {
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _summaryController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SubmitStoryCubit>();
    _titleController = TextEditingController(text: cubit.state.title);
    _authorController = TextEditingController(text: cubit.state.authorName);
    _summaryController = TextEditingController(text: cubit.state.summary);
    _bodyController = TextEditingController(text: cubit.state.body);
  }

  void _syncControllersWithState(SubmitStoryState state) {
    if (_titleController.text != state.title) {
      _titleController.text = state.title;
    }
    if (_authorController.text != state.authorName) {
      _authorController.text = state.authorName;
    }
    if (_summaryController.text != state.summary) {
      _summaryController.text = state.summary;
    }
    if (_bodyController.text != state.body) {
      _bodyController.text = state.body;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _summaryController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SubmitStoryCubit>();

    return BlocListener<SubmitStoryCubit, SubmitStoryState>(
      listenWhen: (previous, current) =>
          previous.title != current.title ||
          previous.authorName != current.authorName ||
          previous.summary != current.summary ||
          previous.body != current.body,
      listener: (context, state) => _syncControllersWithState(state),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // 1. عنوان الحكاية
          _FormFieldLabel(label: 'عنوان الحكاية'),
          _CustomTextField(
            controller: _titleController,
            hint: 'اكتب عنوان الحكاية',
            onChanged: cubit.updateTitle,
          ),
          SizedBox(height: 14.h),

          // 2. اسم الكاتب
          _FormFieldLabel(label: 'اسم الكاتب'),
          _CustomTextField(
            controller: _authorController,
            hint: 'اكتب اسمك',
            onChanged: cubit.updateAuthorName,
          ),
          SizedBox(height: 14.h),

          // 3. وصف مختصر
          _FormFieldLabel(label: 'وصف مختصر'),
          _CustomTextField(
            controller: _summaryController,
            hint: 'اكتب وصف مختصر للحكاية',
            maxLines: 3,
            onChanged: cubit.updateSummary,
          ),
          SizedBox(height: 14.h),

          // 4. Dynamic Body section according to format
          if (widget.format == StorySubmissionFormat.written) ...[
            _FormFieldLabel(label: 'اكتب حكايتك'),
            LongFormStoryEditorField(
              controller: _bodyController,
              hintText: 'اكتب حكايتك هنا...',
              onDebouncedChanged: cubit.updateBody,
            ),
          ] else ...[
            _FormFieldLabel(
              label: widget.format == StorySubmissionFormat.audio
                  ? 'التسجيل الصوتي'
                  : 'الملف المرفق',
            ),
            _CustomPlaceholderBox(
              format: widget.format,
            ),
          ],
          SizedBox(height: 14.h),

          // 5. صورة الغلاف (اختياري)
          _FormFieldLabel(label: 'صورة الغلاف (اختياري)'),
          const _CustomCoverPlaceholderBox(),
          SizedBox(height: 14.h),

          // 6. مربع الموافقة وإظهار الاسم
          const _AnonymousConsentCard(),
          SizedBox(height: 20.h),

          // 7. أزرار التنقل (السابق / مراجعة)
          Row(
            children: [
              // زر السابق
              OutlinedButton.icon(
                onPressed: () => cubit.setStep(1),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: ColorManager.paper100.withValues(alpha: 0.3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                ),
                icon: Icon(
                  Icons.chevron_right_rounded,
                  color: ColorManager.paper100,
                  size: 18.sp,
                ),
                label: Text(
                  'السابق',
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorManager.paper100,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // زر مراجعة
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => cubit.setStep(3),
                    borderRadius: BorderRadius.circular(30.r),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFE8CB7D),
                            Color(0xFFC9A24B),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'مراجعة',
                            style: GoogleFonts.alexandria(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.primaryDark,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            Icons.chevron_left_rounded,
                            color: ColorManager.primaryDark,
                            size: 18.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 60.h),
        ],
      ),
    ),
    );
  }
}

class _FormFieldLabel extends StatelessWidget {
  final String label;
  const _FormFieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        label,
        style: GoogleFonts.ibmPlexSansArabic(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: ColorManager.paper300,
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const _CustomTextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: onChanged,
      style: GoogleFonts.ibmPlexSansArabic(
        fontSize: 14.sp,
        color: ColorManager.paper100,
      ),
      cursorColor: ColorManager.gold,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.ibmPlexSansArabic(
          fontSize: 13.5.sp,
          color: ColorManager.paper400.withValues(alpha: 0.5),
        ),
        filled: true,
        fillColor: ColorManager.primaryLight.withValues(alpha: 0.4),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: ColorManager.gold.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: ColorManager.gold.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: ColorManager.gold.withValues(alpha: 0.4)),
        ),
      ),
    );
  }
}

class _CustomPlaceholderBox extends StatelessWidget {
  final StorySubmissionFormat format;

  const _CustomPlaceholderBox({required this.format});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.primaryLight.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: ColorManager.gold.withValues(alpha: 0.1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(
            switch (format) {
              StorySubmissionFormat.video => CupertinoIcons.videocam_fill,
              StorySubmissionFormat.audio => CupertinoIcons.mic_fill,
              _ => CupertinoIcons.arrow_up_doc_fill,
            },
            color: ColorManager.gold,
            size: 20.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'اختر ملف...',
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 13.5.sp,
                color: ColorManager.paper400.withValues(alpha: 0.5),
              ),
            ),
          ),
          Icon(
            CupertinoIcons.cloud_upload,
            color: ColorManager.gold.withValues(alpha: 0.7),
            size: 20.sp,
          ),
        ],
      ),
    );
  }
}

class _CustomCoverPlaceholderBox extends StatelessWidget {
  const _CustomCoverPlaceholderBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.primaryLight.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: ColorManager.gold.withValues(alpha: 0.1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.photo,
            color: ColorManager.gold,
            size: 20.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'اختر صورة...',
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 13.5.sp,
                color: ColorManager.paper400.withValues(alpha: 0.5),
              ),
            ),
          ),
          Icon(
            Icons.chevron_left_rounded,
            color: ColorManager.gold.withValues(alpha: 0.6),
            size: 20.sp,
          ),
        ],
      ),
    );
  }
}

class _AnonymousConsentCard extends StatelessWidget {
  const _AnonymousConsentCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmitStoryCubit, SubmitStoryState>(
      buildWhen: (prev, curr) => prev.isAnonymous != curr.isAnonymous,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: ColorManager.primaryLight.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: ColorManager.gold.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: Checkbox(
                      value: !state.isAnonymous,
                      activeColor: ColorManager.gold,
                      checkColor: ColorManager.primaryDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      onChanged: (val) {
                        context
                            .read<SubmitStoryCubit>()
                            .toggleAnonymous(!(val ?? true));
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      'أوافق على إظهار اسمي وبياناتي المسموح بنشرها مع الحكاية',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 12.sp,
                        color: ColorManager.paper200.withValues(alpha: 0.75),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              if (state.isAnonymous) ...[
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.exclamationmark_circle,
                      color: ColorManager.gold.withValues(alpha: 0.8),
                      size: 14.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      'سيتم النشر كـ "بدون اسم"',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11.sp,
                        color: ColorManager.gold.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}


