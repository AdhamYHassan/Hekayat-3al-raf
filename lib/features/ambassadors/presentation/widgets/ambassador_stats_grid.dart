import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';

class AmbassadorStatsGrid extends StatelessWidget {
  final int followersCount;
  final int answeredCount;

  const AmbassadorStatsGrid({
    super.key,
    required this.followersCount,
    required this.answeredCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            count: followersCount.toString(),
            label: 'ambassadors.followers_count'.tr(args: ['']).trim(),
            icon: Icons.people_outline_rounded,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _StatCard(
            count: answeredCount.toString(),
            label: 'ambassadors.answered_count'.tr(args: ['']).trim(),
            icon: Icons.question_answer_outlined,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String count;
  final String label;
  final IconData icon;

  const _StatCard({
    required this.count,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: ColorManager.primaryLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: ColorManager.gold.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20.sp,
            color: ColorManager.gold,
          ),
          SizedBox(height: 6.h),
          Text(
            count,
            style: AppFonts.alexandria(
              color: ColorManager.goldLight,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: AppFonts.ibmPlexSansArabic(
              color: ColorManager.paper400,
              fontSize: 11.sp,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
