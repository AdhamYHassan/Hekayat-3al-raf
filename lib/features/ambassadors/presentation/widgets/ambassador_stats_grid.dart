import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';

class AmbassadorStatsGrid extends StatelessWidget {
  final int storiesCount;
  final int answeredQuestionsCount;

  const AmbassadorStatsGrid({
    super.key,
    required this.storiesCount,
    required this.answeredQuestionsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            count: storiesCount.toString(),
            label: 'حكاية',
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatCard(
            count: answeredQuestionsCount.toString(),
            label: 'سؤال تم الرد',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String count;
  final String label;

  const _StatCard({
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: ColorManager.primaryLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: ColorManager.gold.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: GoogleFonts.alexandria(
              color: ColorManager.gold,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: GoogleFonts.ibmPlexSansArabic(
              color: ColorManager.paper400,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}

