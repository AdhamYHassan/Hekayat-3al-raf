import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_cached_network_image.dart';

class AmbassadorHeroHeader extends StatelessWidget {
  final String name;
  final String shortDescription;
  final String coverImageUrl;

  const AmbassadorHeroHeader({
    super.key,
    required this.name,
    required this.shortDescription,
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
          AppCachedNetworkImage(
            imageUrl: coverImageUrl,
            fit: BoxFit.cover,
            alignment: const Alignment(0.0, -0.56), // object-position: 50% 22%
            memCacheWidth: 800,
            memCacheHeight: 640,
          ),

          // Gradient overlay strictly matching prototype DOM
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

          // Name & Role Info
          Positioned(
            bottom: 16.h,
            left: 16.w,
            right: 16.w,
            child: Builder(
              builder: (context) {
                final isArabic = context.locale.languageCode == 'ar';
                final crossAxisAlign = isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start;
                final textAlign = isArabic ? TextAlign.right : TextAlign.left;

                return Column(
                  crossAxisAlignment: crossAxisAlign,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      textAlign: textAlign,
                      style: AppFonts.alexandria(
                        color: ColorManager.paper100,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    if (shortDescription.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        shortDescription,
                        textAlign: textAlign,
                        style: AppFonts.ibmPlexSansArabic(
                          color: ColorManager.goldLight,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
