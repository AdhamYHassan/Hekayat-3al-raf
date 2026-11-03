import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/story_draft_entity.dart';

class DraftRecoveryBanner extends StatelessWidget {
  final StoryDraftEntity draft;
  final VoidCallback onRestore;
  final VoidCallback onDiscard;

  const DraftRecoveryBanner({
    super.key,
    required this.draft,
    required this.onRestore,
    required this.onDiscard,
  });

  @override
  Widget build(BuildContext context) {
    final title = draft.title.trim().isNotEmpty
        ? '«${draft.title.trim()}»'
        : 'submit.draft.unnamed'.tr();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: ColorManager.cardDark.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ColorManager.gold.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.history_toggle_off_rounded,
                color: ColorManager.gold,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'submit.draft.banner_title'.tr(),
                  style: GoogleFonts.alexandria(
                    color: ColorManager.paper100,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onDiscard,
                icon: Icon(
                  Icons.close_rounded,
                  color: ColorManager.paper200.withValues(alpha: 0.5),
                  size: 18.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            'submit.draft.banner_body'.tr(args: [title]),
            style: GoogleFonts.ibmPlexSansArabic(
              color: ColorManager.paper200.withValues(alpha: 0.75),
              fontSize: 11.5.sp,
              height: 1.4,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onRestore,
                  icon: Icon(Icons.restore_page_rounded, size: 16.sp, color: ColorManager.primaryDark),
                  label: Text(
                    'submit.draft.restore'.tr(),
                    style: GoogleFonts.alexandria(
                      color: ColorManager.primaryDark,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.gold,
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              TextButton(
                onPressed: onDiscard,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                ),
                child: Text(
                  'submit.draft.discard'.tr(),
                  style: GoogleFonts.ibmPlexSansArabic(
                    color: ColorManager.paper200.withValues(alpha: 0.6),
                    fontSize: 11.5.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

