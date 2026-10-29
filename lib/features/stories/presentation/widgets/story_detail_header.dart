import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';

class StoryDetailHeader extends StatelessWidget {
  final VoidCallback onBackTap;

  const StoryDetailHeader({
    super.key,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: ColorManager.primaryDark.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: ColorManager.gold.withValues(alpha: 0.2),
            width: 1.h,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.network(
            'https://hekayat-ala-el-raff-m9tr.bolt.host/brand/logo-gold.webp',
            height: 32.h,
            errorBuilder: (context, error, stackTrace) => Text(
              'حكايات على الرف',
              style: GoogleFonts.arefRuqaa(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: ColorManager.gold,
              ),
            ),
          ),
          InkWell(
            onTap: onBackTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'رجوع',
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorManager.goldLight,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  CupertinoIcons.arrow_left,
                  size: 14.sp,
                  color: ColorManager.goldLight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

