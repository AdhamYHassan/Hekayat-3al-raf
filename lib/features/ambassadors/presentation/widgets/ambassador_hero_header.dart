import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';

class AmbassadorHeroHeader extends StatelessWidget {
  final String name;
  final String role;
  final String cityAndJoin;
  final String coverImageUrl;

  const AmbassadorHeroHeader({
    super.key,
    required this.name,
    required this.role,
    required this.cityAndJoin,
    required this.coverImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Cover Image with physical decoding dimensions
          Image.network(
            coverImageUrl,
            fit: BoxFit.cover,
            alignment: const Alignment(0.0, -0.56), // object-position: 50% 22%
            cacheWidth: 800,
            errorBuilder: (context, error, stackTrace) => Container(
              color: ColorManager.primaryLight,
            ),
          ),

          // Gradient overlay strictly matching prototype DOM (only fade to dark at the bottom)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  ColorManager.primaryDark.withValues(alpha: 0.6),
                  ColorManager.primaryDark,
                ],
                stops: const [0.0, 0.45, 0.75, 1.0],
              ),
            ),
          ),

          // Name, Role & Location Info
          Positioned(
            bottom: 16.h,
            left: 16.w,
            right: 16.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.alexandria(
                    color: ColorManager.paper100,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  role,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.ibmPlexSansArabic(
                    color: ColorManager.goldLight,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  cityAndJoin,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.ibmPlexSansArabic(
                    color: ColorManager.paper400,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

