import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/helpers/direction_extension.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_snack_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_entities.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/bloc/submit_story_cubit.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/bloc/submit_story_state.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/widgets/audio_story_recorder_box.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/widgets/long_form_story_editor_field.dart';

/// [SubmitStoryStep2Form] renders the exact responsive HTML/Tailwind form layout:
/// - Written: Title, Author, Summary, Write Story (multi-line), Cover Image, Anonymous checkbox.
/// - Video/Document: Title, Author, Summary, "ارفع الملف" button with status indicator, Cover Image, Anonymous.
/// - Audio: Title, Author, Summary, Native 30-min long recording card with timer and waveform controls.
class SubmitStoryStep2Form extends StatefulWidget {
  final StorySubmissionFormat format;

  const SubmitStoryStep2Form({super.key, required this.format});

  @override
  State<SubmitStoryStep2Form> createState() => _SubmitStoryStep2FormState();
}

class _SubmitStoryStep2FormState extends State<SubmitStoryStep2Form> {
  late final TextEditingController _titleController;
  late final TextEditingController _authorController;
  late final TextEditingController _summaryController;
  late final TextEditingController _bodyController;

  String? _titleError;
  String? _authorError;
  String? _summaryError;
  String? _bodyError;
  String? _attachmentError;

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

  bool _validateForm() {
    final cubit = context.read<SubmitStoryCubit>();
    bool isValid = true;

    if (_titleController.text.trim().isEmpty) {
      _titleError = 'validation.title_required'.tr();
      isValid = false;
    } else {
      _titleError = null;
    }

    if (_authorController.text.trim().isEmpty) {
      _authorError = 'validation.author_required'.tr();
      isValid = false;
    } else {
      _authorError = null;
    }

    if (_summaryController.text.trim().isEmpty) {
      _summaryError = 'validation.summary_required'.tr();
      isValid = false;
    } else if (_summaryController.text.trim().length < 20) {
      _summaryError = 'validation.summary_too_short'.tr();
      isValid = false;
    } else if (_summaryController.text.trim().length > 280) {
      _summaryError = 'validation.summary_max_length'.tr();
      isValid = false;
    } else {
      _summaryError = null;
    }

    if (widget.format == StorySubmissionFormat.written) {
      if (_bodyController.text.trim().isEmpty) {
        _bodyError = 'validation.body_required'.tr();
        isValid = false;
      } else if (_bodyController.text.trim().length < 150) {
        _bodyError = 'validation.body_too_short'.tr();
        isValid = false;
      } else if (_bodyController.text.trim().length > 12000) {
        _bodyError = 'validation.body_max_length'.tr();
        isValid = false;
      } else {
        _bodyError = null;
      }
      _attachmentError = null;
    } else if (widget.format == StorySubmissionFormat.audio) {
      if (cubit.state.recordedAudioPath == null ||
          cubit.state.recordedAudioPath!.isEmpty) {
        _attachmentError = 'validation.audio_required'.tr();
        isValid = false;
      } else {
        _attachmentError = null;
      }
      _bodyError = null;
    } else if (widget.format == StorySubmissionFormat.video) {
      if (cubit.state.attachedFilePath == null ||
          cubit.state.attachedFilePath!.isEmpty) {
        _attachmentError = 'validation.video_required'.tr();
        isValid = false;
      } else {
        _attachmentError = null;
      }
      _bodyError = null;
    } else if (widget.format == StorySubmissionFormat.document) {
      if (cubit.state.attachedFilePath == null ||
          cubit.state.attachedFilePath!.isEmpty) {
        _attachmentError = 'validation.document_required'.tr();
        isValid = false;
      } else {
        _attachmentError = null;
      }
      _bodyError = null;
    }

    setState(() {});
    return isValid;
  }

  bool _isFormValid(SubmitStoryState state) {
    if (state.title.trim().isEmpty) return false;
    if (state.authorName.trim().isEmpty) return false;
    if (state.summary.trim().length < 20 ||
        state.summary.trim().length > 280) {
      return false;
    }

    return switch (widget.format) {
      StorySubmissionFormat.written =>
        state.body.trim().length >= 150 && state.body.trim().length <= 12000,
      StorySubmissionFormat.audio =>
        state.recordedAudioPath != null && state.recordedAudioPath!.isNotEmpty,
      StorySubmissionFormat.video || StorySubmissionFormat.document =>
        state.attachedFilePath != null && state.attachedFilePath!.isNotEmpty,
    };
  }

  void _onReviewTap(SubmitStoryCubit cubit) {
    if (_validateForm()) {
      cubit.setStep(3);
    } else {
      // Find the first missing or invalid field and announce it via AppSnackBar
      final firstError = _titleError ??
          _authorError ??
          _summaryError ??
          _bodyError ??
          _attachmentError;
      if (firstError != null && mounted) {
        AppSnackBar.showError(context, message: firstError);
      }
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
            _FormFieldLabel(
              label: 'submit.form.title_label'.tr(),
              isRequired: true,
            ),
            _CustomTextField(
              controller: _titleController,
              hint: 'submit.form.title_hint'.tr(),
              errorMessage: _titleError,
              onChanged: (val) {
                cubit.updateTitle(val);
                if (_titleError != null) {
                  setState(() => _titleError = null);
                }
              },
            ),
            SizedBox(height: 14.h),

            // 2. اسم الكاتب
            _FormFieldLabel(
              label: 'submit.form.author_label'.tr(),
              isRequired: true,
            ),
            _CustomTextField(
              controller: _authorController,
              hint: 'submit.form.author_hint'.tr(),
              errorMessage: _authorError,
              onChanged: (val) {
                cubit.updateAuthorName(val);
                if (_authorError != null) {
                  setState(() => _authorError = null);
                }
              },
            ),
            SizedBox(height: 14.h),

            // 3. وصف مختصر
            _FormFieldLabel(
              label: 'submit.form.description_label'.tr(),
              isRequired: true,
              subtitleHint: 'submit.form.description_hint_chars'.tr(),
            ),
            _CustomTextField(
              controller: _summaryController,
              hint: 'submit.form.description_hint'.tr(),
              maxLines: 3,
              maxLength: 280,
              errorMessage: _summaryError,
              onChanged: (val) {
                cubit.updateSummary(val);
                if (_summaryError != null) {
                  setState(() => _summaryError = null);
                }
              },
            ),
            SizedBox(height: 14.h),

            // 4. Dynamic Body section according to format
            if (widget.format == StorySubmissionFormat.written) ...[
              _FormFieldLabel(
                label: 'submit.form.story_label'.tr(),
                isRequired: true,
                subtitleHint: 'submit.form.story_min_chars_hint'.tr(),
              ),
              LongFormStoryEditorField(
                controller: _bodyController,
                hintText: 'submit.form.story_hint'.tr(),
                onDebouncedChanged: (val) {
                  cubit.updateBody(val);
                  if (_bodyError != null && val.trim().isNotEmpty) {
                    setState(() => _bodyError = null);
                  }
                },
              ),
              if (_bodyError != null)
                Padding(
                  padding: EdgeInsets.only(top: 6.h, right: 4.w, left: 4.w),
                  child: Text(
                    _bodyError!,
                    style: AppFonts.ibmPlexSansArabic(
                      color: ColorManager.error,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ] else if (widget.format == StorySubmissionFormat.audio) ...[
              _FormFieldLabel(
                label: 'submit.form.audio_label'.tr(),
                isRequired: true,
              ),
              BlocBuilder<SubmitStoryCubit, SubmitStoryState>(
                buildWhen: (prev, curr) =>
                    prev.recordedAudioPath != curr.recordedAudioPath ||
                    prev.recordingDurationSeconds !=
                        curr.recordingDurationSeconds,
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AudioStoryRecorderBox(
                        initialAudioPath: state.recordedAudioPath,
                        initialDurationSeconds: state.recordingDurationSeconds,
                        onRecordingCompleted: (path, durationSeconds) {
                          cubit.setRecordedAudio(
                            path: path,
                            durationSeconds: durationSeconds,
                          );
                          if (_attachmentError != null) {
                            setState(() => _attachmentError = null);
                          }
                        },
                        onRecordingCleared: () {
                          cubit.clearRecordedAudio();
                        },
                      ),
                      if (_attachmentError != null)
                        Padding(
                          padding: EdgeInsets.only(
                            top: 6.h,
                            right: 4.w,
                            left: 4.w,
                          ),
                          child: Text(
                            _attachmentError!,
                            style: AppFonts.ibmPlexSansArabic(
                              color: ColorManager.error,
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ] else ...[
              _FormFieldLabel(
                label: 'submit.form.file_label'.tr(),
                isRequired: true,
                subtitleHint: widget.format == StorySubmissionFormat.video
                    ? 'submit.form.video_hint_specs'.tr()
                    : 'submit.form.document_hint_specs'.tr(),
              ),
              _CustomPlaceholderBox(
                format: widget.format,
                hasError: _attachmentError != null,
                onFilePicked: () {
                  if (_attachmentError != null) {
                    setState(() => _attachmentError = null);
                  }
                },
              ),
              if (_attachmentError != null)
                Padding(
                  padding: EdgeInsets.only(top: 6.h, right: 4.w, left: 4.w),
                  child: Text(
                    _attachmentError!,
                    style: AppFonts.ibmPlexSansArabic(
                      color: ColorManager.error,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
            SizedBox(height: 14.h),

            // 5. صورة الغلاف (اختياري)
            _FormFieldLabel(
              label: 'submit.form.cover_label'.tr(),
              isRequired: false,
              subtitleHint: 'submit.form.cover_hint_specs'.tr(),
            ),
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

                // زر مراجعة
                Expanded(
                  child: BlocBuilder<SubmitStoryCubit, SubmitStoryState>(
                    buildWhen: (prev, curr) =>
                        prev.title != curr.title ||
                        prev.authorName != curr.authorName ||
                        prev.summary != curr.summary ||
                        prev.body != curr.body ||
                        prev.attachedFilePath != curr.attachedFilePath ||
                        prev.recordedAudioPath != curr.recordedAudioPath,
                    builder: (context, state) {
                      final isValid = _isFormValid(state);
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _onReviewTap(cubit),
                          borderRadius: BorderRadius.circular(30.r),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: isValid ? 1.0 : 0.45,
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: isValid
                                    ? const LinearGradient(
                                        colors: [
                                          Color(0xFFE8CB7D),
                                          Color(0xFFC9A24B),
                                        ],
                                      )
                                    : null,
                                color: isValid
                                    ? null
                                    : ColorManager.primaryLight
                                        .withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(30.r),
                                border: Border.all(
                                  color: isValid
                                      ? Colors.transparent
                                      : ColorManager.gold
                                          .withValues(alpha: 0.25),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'submit.review'.tr(),
                                    style: AppFonts.alexandria(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: isValid
                                          ? ColorManager.primaryDark
                                          : ColorManager.paper300,
                                    ),
                                  ),
                                  SizedBox(width: 6.w),
                                  Icon(
                                    context.forwardChevron,
                                    color: isValid
                                        ? ColorManager.primaryDark
                                        : ColorManager.paper300,
                                    size: 18.sp,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
  final bool isRequired;
  final String? subtitleHint;

  const _FormFieldLabel({
    required this.label,
    this.isRequired = false,
    this.subtitleHint,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppFonts.ibmPlexSansArabic(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorManager.paper300,
                ),
              ),
              if (isRequired) ...[
                SizedBox(width: 4.w),
                Text(
                  '*',
                  style: AppFonts.alexandria(
                    fontSize: 13.sp,
                    color: ColorManager.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          if (subtitleHint != null)
            Text(
              subtitleHint!,
              style: AppFonts.ibmPlexSansArabic(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: ColorManager.gold.withValues(alpha: 0.8),
              ),
            ),
        ],
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final int? maxLength;
  final String? errorMessage;
  final ValueChanged<String>? onChanged;

  const _CustomTextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.maxLength,
    this.errorMessage,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorMessage != null && errorMessage!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          onChanged: onChanged,
          buildCounter: maxLength != null
              ? (
                  context, {
                  required currentLength,
                  required isFocused,
                  maxLength,
                }) => Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    '$currentLength / $maxLength',
                    style: AppFonts.ibmPlexSansArabic(
                      fontSize: 11.sp,
                      color: currentLength > (maxLength ?? 0)
                          ? ColorManager.error
                          : ColorManager.paper400.withValues(alpha: 0.6),
                    ),
                  ),
                )
              : null,
          style: AppFonts.ibmPlexSansArabic(
            fontSize: 14.sp,
            color: ColorManager.paper100,
          ),
          cursorColor: ColorManager.gold,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppFonts.ibmPlexSansArabic(
              fontSize: 13.5.sp,
              color: ColorManager.paper400.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: ColorManager.primaryLight.withValues(alpha: 0.4),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: hasError
                    ? ColorManager.error
                    : ColorManager.gold.withValues(alpha: 0.1),
                width: hasError ? 1.2 : 1.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: hasError
                    ? ColorManager.error
                    : ColorManager.gold.withValues(alpha: 0.1),
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
            padding: EdgeInsets.only(top: 5.h, right: 4.w, left: 4.w),
            child: Text(
              errorMessage!,
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
}

class _CustomPlaceholderBox extends StatelessWidget {
  final StorySubmissionFormat format;
  final bool hasError;
  final VoidCallback? onFilePicked;

  const _CustomPlaceholderBox({
    required this.format,
    this.hasError = false,
    this.onFilePicked,
  });

  Future<void> _pickFile(BuildContext context) async {
    final cubit = context.read<SubmitStoryCubit>();
    try {
      if (format == StorySubmissionFormat.video) {
        final picker = ImagePicker();
        final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
        if (pickedVideo != null) {
          final file = File(pickedVideo.path);

          // 1. Validate format (MP4, MOV, WEBM)
          final extension = pickedVideo.path.split('.').last.toLowerCase();
          const allowedExtensions = {'mp4', 'mov', 'webm'};
          if (!allowedExtensions.contains(extension)) {
            cubit.setAttachedFilePath(null);
            if (context.mounted) {
              AppSnackBar.showError(
                context,
                message: 'validation.video_format_not_supported'.tr(),
              );
            }
            return;
          }

          // 2. Validate size (Max 500 MB = 500 * 1024 * 1024 bytes)
          const maxVideoSizeBytes = 500 * 1024 * 1024;
          final fileSizeBytes = await file.length();
          final fileSizeMb = fileSizeBytes / (1024 * 1024);

          debugPrint(
            '🎬 [VideoPicker] Path: ${pickedVideo.path}\n'
            '🎬 [VideoPicker] Format: .$extension\n'
            '🎬 [VideoPicker] Size: ${fileSizeMb.toStringAsFixed(2)} MB ($fileSizeBytes Bytes) / Max: 500 MB',
          );

          if (fileSizeBytes > maxVideoSizeBytes) {
            cubit.setAttachedFilePath(null);
            if (context.mounted) {
              AppSnackBar.showError(
                context,
                message: 'validation.video_size_limit_exceeded'.tr(),
              );
            }
            return;
          }

          cubit.setAttachedFilePath(pickedVideo.path);
          onFilePicked?.call();
        }
      } else {
        // Document picker: PDF, DOC, DOCX (Max 50 MB)
        final result = await FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docx'],
        );
        if (result.isNotEmpty && result.first.path != null) {
          final filePath = result.first.path!;
          final file = File(filePath);
          const maxDocumentSizeBytes = 50 * 1024 * 1024; // 50 MB
          final fileSizeBytes = await file.length();
          final fileSizeMb = fileSizeBytes / (1024 * 1024);

          debugPrint(
            '📄 [DocumentPicker] Path: $filePath\n'
            '📄 [DocumentPicker] Size: ${fileSizeMb.toStringAsFixed(2)} MB ($fileSizeBytes Bytes) / Max: 50 MB',
          );

          if (fileSizeBytes > maxDocumentSizeBytes) {
            cubit.setAttachedFilePath(null);
            if (context.mounted) {
              AppSnackBar.showError(
                context,
                message: 'validation.document_size_limit_exceeded'.tr(),
              );
            }
            return;
          }

          cubit.setAttachedFilePath(filePath);
          onFilePicked?.call();
        }
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmitStoryCubit, SubmitStoryState>(
      buildWhen: (prev, curr) => prev.attachedFilePath != curr.attachedFilePath,
      builder: (context, state) {
        final hasFile =
            state.attachedFilePath != null &&
            state.attachedFilePath!.isNotEmpty;
        final fileName = hasFile
            ? state.attachedFilePath!.split('/').last
            : null;

        return InkWell(
          onTap: () => _pickFile(context),
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            decoration: BoxDecoration(
              color: ColorManager.primaryLight.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: hasError
                    ? ColorManager.error
                    : hasFile
                    ? ColorManager.gold
                    : ColorManager.gold.withValues(alpha: 0.1),
                width: hasError || hasFile ? 1.5 : 1.0,
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
                  color: hasError ? ColorManager.error : ColorManager.gold,
                  size: 20.sp,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    hasFile ? fileName! : 'submit.form.choose_file'.tr(),
                    style: AppFonts.ibmPlexSansArabic(
                      fontSize: 13.5.sp,
                      color: hasFile
                          ? ColorManager.paper100
                          : ColorManager.paper400.withValues(alpha: 0.5),
                      fontWeight: hasFile ? FontWeight.w600 : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasFile)
                  GestureDetector(
                    onTap: () => context
                        .read<SubmitStoryCubit>()
                        .setAttachedFilePath(null),
                    child: Icon(
                      CupertinoIcons.xmark_circle_fill,
                      color: ColorManager.paper400,
                      size: 20.sp,
                    ),
                  )
                else
                  Icon(
                    CupertinoIcons.cloud_upload,
                    color: ColorManager.gold.withValues(alpha: 0.7),
                    size: 20.sp,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CustomCoverPlaceholderBox extends StatelessWidget {
  const _CustomCoverPlaceholderBox();

  Future<void> _pickImage(BuildContext context) async {
    final cubit = context.read<SubmitStoryCubit>();
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (pickedImage != null) {
        final file = File(pickedImage.path);
        const maxThumbnailSizeBytes = 15 * 1024 * 1024; // 15 MB
        final fileSizeBytes = await file.length();
        final fileSizeMb = fileSizeBytes / (1024 * 1024);

        debugPrint(
          '🖼️ [ThumbnailPicker] Path: ${pickedImage.path}\n'
          '🖼️ [ThumbnailPicker] Size: ${fileSizeMb.toStringAsFixed(2)} MB ($fileSizeBytes Bytes) / Max: 15 MB',
        );

        if (fileSizeBytes > maxThumbnailSizeBytes) {
          cubit.setCoverImagePath(null);
          if (context.mounted) {
            AppSnackBar.showError(
              context,
              message: 'validation.thumbnail_size_limit_exceeded'.tr(),
            );
          }
          return;
        }

        cubit.setCoverImagePath(pickedImage.path);
      }
    } catch (e) {
      debugPrint('Error picking cover image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmitStoryCubit, SubmitStoryState>(
      buildWhen: (prev, curr) => prev.coverImagePath != curr.coverImagePath,
      builder: (context, state) {
        final hasImage =
            state.coverImagePath != null && state.coverImagePath!.isNotEmpty;
        final imageName = hasImage
            ? state.coverImagePath!.split('/').last
            : null;

        return InkWell(
          onTap: () => _pickImage(context),
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            decoration: BoxDecoration(
              color: ColorManager.primaryLight.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: hasImage
                    ? ColorManager.gold
                    : ColorManager.gold.withValues(alpha: 0.1),
                width: hasImage ? 1.5 : 1.0,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: [
                if (hasImage)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: Image.file(
                      File(state.coverImagePath!),
                      width: 24.w,
                      height: 24.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        CupertinoIcons.photo,
                        color: ColorManager.gold,
                        size: 20.sp,
                      ),
                    ),
                  )
                else
                  Icon(
                    CupertinoIcons.photo,
                    color: ColorManager.gold,
                    size: 20.sp,
                  ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    hasImage ? imageName! : 'submit.form.choose_image'.tr(),
                    style: AppFonts.ibmPlexSansArabic(
                      fontSize: 13.5.sp,
                      color: hasImage
                          ? ColorManager.paper100
                          : ColorManager.paper400.withValues(alpha: 0.5),
                      fontWeight: hasImage
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasImage)
                  GestureDetector(
                    onTap: () => context
                        .read<SubmitStoryCubit>()
                        .setCoverImagePath(null),
                    child: Icon(
                      CupertinoIcons.xmark_circle_fill,
                      color: ColorManager.paper400,
                      size: 20.sp,
                    ),
                  )
                else
                  Icon(
                    context.forwardChevron,
                    color: ColorManager.gold.withValues(alpha: 0.6),
                    size: 20.sp,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnonymousConsentCard extends StatelessWidget {
  const _AnonymousConsentCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmitStoryCubit, SubmitStoryState>(
      buildWhen: (prev, curr) => prev.showAuthor != curr.showAuthor,
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
                      value: state.showAuthor, // Default false: unchecked
                      activeColor: ColorManager.gold,
                      checkColor: ColorManager.primaryDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      onChanged: (val) {
                        context.read<SubmitStoryCubit>().toggleShowAuthor(
                          val ?? false,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        context.read<SubmitStoryCubit>().toggleShowAuthor(
                          !state.showAuthor,
                        );
                      },
                      child: Text(
                        'submit.anonymous_toggle'.tr(),
                        style: AppFonts.ibmPlexSansArabic(
                          fontSize: 12.sp,
                          color: ColorManager.paper200.withValues(alpha: 0.75),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (!state.showAuthor) ...[
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
                      'submit.anonymous_hint'.tr(),
                      style: AppFonts.ibmPlexSansArabic(
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
