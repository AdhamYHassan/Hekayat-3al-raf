import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_entities.dart';

class StoryTypeCard extends StatelessWidget {
  final StoryTypeOptionEntity option;
  final bool isSelected;
  final VoidCallback onTap;

  const StoryTypeCard({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  IconData _getIcon(StorySubmissionFormat format) {
    return switch (format) {
      StorySubmissionFormat.written => Icons.menu_book_rounded,
      StorySubmissionFormat.audio => Icons.headphones_rounded,
      StorySubmissionFormat.video => Icons.videocam_rounded,
      StorySubmissionFormat.document => Icons.description_rounded,
    };
  }

  String _getTitle(StorySubmissionFormat format) {
    return switch (format) {
      StorySubmissionFormat.written => 'submit.type_options.written_title'.tr(),
      StorySubmissionFormat.audio => 'submit.type_options.audio_title'.tr(),
      StorySubmissionFormat.video => 'submit.type_options.video_title'.tr(),
      StorySubmissionFormat.document => 'submit.type_options.document_title'.tr(),
    };
  }

  String _getDescription(StorySubmissionFormat format) {
    return switch (format) {
      StorySubmissionFormat.written => 'submit.type_options.written_desc'.tr(),
      StorySubmissionFormat.audio => 'submit.type_options.audio_desc'.tr(),
      StorySubmissionFormat.video => 'submit.type_options.video_desc'.tr(),
      StorySubmissionFormat.document => 'submit.type_options.document_desc'.tr(),
    };
  }

  List<String> _getBadges(StorySubmissionFormat format) {
    return switch (format) {
      StorySubmissionFormat.written => [
          'submit.type_options.written_badge1'.tr(),
          'submit.type_options.written_badge2'.tr(),
          'submit.type_options.written_badge3'.tr(),
        ],
      StorySubmissionFormat.audio => [
          'submit.type_options.audio_badge1'.tr(),
          'submit.type_options.audio_badge2'.tr(),
          'submit.type_options.audio_badge3'.tr(),
        ],
      StorySubmissionFormat.video => [
          'submit.type_options.video_badge1'.tr(),
          'submit.type_options.video_badge2'.tr(),
          'submit.type_options.video_badge3'.tr(),
        ],
      StorySubmissionFormat.document => [
          'submit.type_options.document_badge1'.tr(),
          'submit.type_options.document_badge2'.tr(),
          'submit.type_options.document_badge3'.tr(),
        ],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isSelected
                ? ColorManager.gold.withValues(alpha: 0.15)
                : ColorManager.primaryLight.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? ColorManager.gold.withValues(alpha: 0.6)
                  : ColorManager.gold.withValues(alpha: 0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circular Icon Container
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? ColorManager.gold.withValues(alpha: 0.25)
                      : ColorManager.gold.withValues(alpha: 0.1),
                ),
                child: Center(
                  child: Icon(
                    _getIcon(option.format),
                    color: isSelected ? ColorManager.gold : ColorManager.goldLight,
                    size: 24.sp,
                  ),
                ),
              ),
              SizedBox(width: 14.w),

              // Title, Description & Badges
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getTitle(option.format),
                          style: AppFonts.alexandria(
                            color: ColorManager.paper100,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_rounded,
                            color: ColorManager.gold,
                            size: 20.sp,
                          ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      _getDescription(option.format),
                      style: AppFonts.ibmPlexSansArabic(
                        color: ColorManager.paper200.withValues(alpha: 0.65),
                        fontSize: 12.sp,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 4.h,
                      children: _getBadges(option.format).map((badge) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: ColorManager.paper400.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            badge,
                            style: AppFonts.ibmPlexSansArabic(
                              color: ColorManager.paper300,
                              fontSize: 10.sp,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

