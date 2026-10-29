import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';

class HomeShareCtaCard extends StatelessWidget {
  final VoidCallback onSubmitTap;

  const HomeShareCtaCard({
    super.key,
    required this.onSubmitTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          // 1. Podcast Opportunity Card
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3B0D1A),
                  Color(0xFF220610),
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: ColorManager.gold.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: ColorManager.gold.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorManager.gold.withValues(alpha: 0.3)),
                      ),
                      child: Icon(CupertinoIcons.mic, size: 20.sp, color: ColorManager.gold),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'home.podcast_kicker'.tr(),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorManager.gold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Text(
                  'home.podcast_body'.tr(),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 14.sp,
                    color: ColorManager.paper100,
                    height: 1.85,
                  ),
                ),
                SizedBox(height: 20.h),
                InkWell(
                  onTap: onSubmitTap,
                  borderRadius: BorderRadius.circular(24.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: ColorManager.gold,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'home.podcast_cta'.tr(),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorManager.primaryDark,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(CupertinoIcons.arrow_left, size: 14.sp, color: ColorManager.primaryDark),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // 2. Turn Card (دورك)
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4A0F20),
                  Color(0xFF220610),
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: ColorManager.gold.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 20.w, height: 1.h, color: ColorManager.gold),
                    SizedBox(width: 8.w),
                    Text(
                      'home.share_kicker'.tr(),
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorManager.gold,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(width: 20.w, height: 1.h, color: ColorManager.gold),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  'home.share_title'.tr(),
                  style: GoogleFonts.alexandria(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorManager.paper100,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'home.share_body'.tr(),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 13.sp,
                    color: ColorManager.paper200.withValues(alpha: 0.7),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                InkWell(
                  onTap: onSubmitTap,
                  borderRadius: BorderRadius.circular(24.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: ColorManager.gold,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'home.share_cta'.tr(),
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorManager.primaryDark,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(CupertinoIcons.arrow_left, size: 16.sp, color: ColorManager.primaryDark),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // 3. Stats Grid (3 Columns)
          Row(
            children: [
              _buildStatItem('+٥٠٠', 'home.stats_submitted'.tr()),
              SizedBox(width: 12.w),
              _buildStatItem('+١٢٠', 'home.stats_published'.tr()),
              SizedBox(width: 12.w),
              _buildStatItem('+١٠آلاف', 'home.stats_readers'.tr()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String count, String label) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: ColorManager.primaryLight.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: ColorManager.gold.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: GoogleFonts.alexandria(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: ColorManager.gold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 10.sp,
                color: ColorManager.paper200.withValues(alpha: 0.6),
                height: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
