import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';

class MoreLanguageSelector extends StatelessWidget {
  final String currentLocale;
  final ValueChanged<String> onLocaleChanged;

  const MoreLanguageSelector({
    super.key,
    required this.currentLocale,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = currentLocale == 'ar';

    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onLocaleChanged('ar'),
              borderRadius: BorderRadius.circular(12.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 11.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isArabic
                      ? ColorManager.gold.withValues(alpha: 0.15)
                      : ColorManager.primaryLight.withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isArabic
                        ? ColorManager.gold.withValues(alpha: 0.35)
                        : ColorManager.gold.withValues(alpha: 0.08),
                  ),
                ),
                child: Text(
                  'العربية',
                  style: AppFonts.alexandria(
                    fontSize: 13.sp,
                    fontWeight: isArabic ? FontWeight.bold : FontWeight.w500,
                    color: isArabic ? ColorManager.gold : ColorManager.paper400,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onLocaleChanged('en'),
              borderRadius: BorderRadius.circular(12.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 11.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isArabic
                      ? ColorManager.gold.withValues(alpha: 0.15)
                      : ColorManager.primaryLight.withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: !isArabic
                        ? ColorManager.gold.withValues(alpha: 0.35)
                        : ColorManager.gold.withValues(alpha: 0.08),
                  ),
                ),
                child: Text(
                  'English',
                  style: AppFonts.alexandria(
                    fontSize: 13.sp,
                    fontWeight: !isArabic ? FontWeight.bold : FontWeight.w500,
                    color:
                        !isArabic ? ColorManager.gold : ColorManager.paper400,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

