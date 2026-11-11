import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_cached_network_image.dart';

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
          AppCachedNetworkImage(
            imageUrl: 'https://hekayat-ala-el-raff-m9tr.bolt.host/brand/logo-gold.webp',
            height: 32.h,
            fit: BoxFit.contain,
            memCacheHeight: 90,
            errorWidget: Text(
              'app_name'.tr(),
              style: AppFonts.arefRuqaa(
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
                  'common.back'.tr(),
                  style: AppFonts.ibmPlexSansArabic(
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

