import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';

/// Standard, production-grade back button with platform-compliant directionality:
/// - Arabic (RTL): [Text: رجوع] [Icon: >]
/// - English (LTR): [Icon: <] [Text: Back]
class AppBackButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? color;
  final double? fontSize;
  final bool withBackground;

  const AppBackButton({
    super.key,
    this.onTap,
    this.color,
    this.fontSize,
    this.withBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final textColor = color ?? ColorManager.goldLight;
    final iconColor = color ?? ColorManager.goldLight;

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isArabic) ...[
          Icon(
            Icons.arrow_back_ios_new_rounded,
            color: iconColor,
            size: 13.sp,
          ),
          SizedBox(width: 4.w),
        ],
        Text(
          'common.back'.tr(),
          style: AppFonts.ibmPlexSansArabic(
            fontSize: fontSize ?? 13.sp,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        if (isArabic) ...[
          SizedBox(width: 4.w),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: iconColor,
            size: 13.sp,
          ),
        ],
      ],
    );

    if (withBackground) {
      content = Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 6.h,
        ),
        decoration: BoxDecoration(
          color: ColorManager.primaryDark.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: ColorManager.gold.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: content,
      );
    }

    return InkWell(
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      borderRadius: BorderRadius.circular(20.r),
      child: content,
    );
  }
}

