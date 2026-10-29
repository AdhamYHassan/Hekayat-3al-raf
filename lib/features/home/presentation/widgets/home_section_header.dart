import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';

class HomeSectionHeader extends StatelessWidget {
  final String kicker;
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const HomeSectionHeader({
    super.key,
    required this.kicker,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 20.w,
                    height: 1.2.h,
                    color: ColorManager.gold,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    kicker,
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorManager.gold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.h),
              Text(
                title,
                style: GoogleFonts.alexandria(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: ColorManager.paper100,
                  height: 1.2,
                ),
              ),
            ],
          ),
          if (actionLabel != null && onActionTap != null)
            InkWell(
              onTap: onActionTap,
              splashColor: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.only(bottom: 2.h),
                child: Text(
                  actionLabel!,
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorManager.goldLight,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
