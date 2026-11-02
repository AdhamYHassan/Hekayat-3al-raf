import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';

class MoreMenuItemCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isHighlighted;

  const MoreMenuItemCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isHighlighted
        ? ColorManager.gold.withValues(alpha: 0.10)
        : ColorManager.primaryLight.withValues(alpha: 0.30);

    final borderColor = isHighlighted
        ? ColorManager.gold.withValues(alpha: 0.25)
        : ColorManager.gold.withValues(alpha: 0.08);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? ColorManager.gold.withValues(alpha: 0.15)
                      : ColorManager.gold.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color:
                      isHighlighted ? ColorManager.gold : ColorManager.goldLight,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.alexandria(
                        color: ColorManager.paper100,
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: GoogleFonts.ibmPlexSansArabic(
                        color: ColorManager.paper400,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_left_rounded,
                color: ColorManager.gold.withValues(alpha: 0.45),
                size: 20.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

