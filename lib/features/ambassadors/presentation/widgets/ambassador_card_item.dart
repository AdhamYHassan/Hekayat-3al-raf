import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_list_item_entity.dart';

class AmbassadorCardItem extends StatelessWidget {
  final AmbassadorListItemEntity ambassador;
  final VoidCallback onTap;

  const AmbassadorCardItem({
    super.key,
    required this.ambassador,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            height: 192.h,
            decoration: BoxDecoration(
              color: ColorManager.primaryLight,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: ColorManager.gold.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Cover Image with matched decoding dimensions
                Image.network(
                  ambassador.imageUrl,
                  fit: BoxFit.cover,
                  alignment: const Alignment(0.0, -0.56), // object-position: 50% 22%
                  cacheWidth: 800,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: ColorManager.primaryLight),
                ),

                // Dark gradient overlay strictly matching prototype DOM
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        ColorManager.primaryDark.withValues(alpha: 0.4),
                        ColorManager.primaryDark.withValues(alpha: 0.95),
                      ],
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                ),

                // Chevron icon indicating navigation
                PositionedDirectional(
                  start: 12.w,
                  top: 12.h,
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: ColorManager.gold.withValues(alpha: 0.6),
                    size: 20.sp,
                  ),
                ),

                // Content Info at the bottom
                Positioned(
                  bottom: 12.h,
                  left: 14.w,
                  right: 14.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ambassador.name,
                        style: GoogleFonts.alexandria(
                          color: ColorManager.paper100,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        ambassador.role,
                        style: GoogleFonts.ibmPlexSansArabic(
                          color: ColorManager.goldLight,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        ambassador.quote,
                        style: GoogleFonts.ibmPlexSansArabic(
                          color: ColorManager.paper200.withValues(alpha: 0.7),
                          fontSize: 12.sp,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Text(
                            '${ambassador.storiesCount} حكاية',
                            style: GoogleFonts.ibmPlexSansArabic(
                              color: ColorManager.paper400,
                              fontSize: 10.sp,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: Text(
                              '·',
                              style: TextStyle(
                                color: ColorManager.paper400,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                          Text(
                            '${ambassador.answeredQuestionsCount} سؤال تم الرد',
                            style: GoogleFonts.ibmPlexSansArabic(
                              color: ColorManager.paper400,
                              fontSize: 10.sp,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6.w),
                            child: Text(
                              '·',
                              style: TextStyle(
                                color: ColorManager.paper400,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                          Text(
                            ambassador.city,
                            style: GoogleFonts.ibmPlexSansArabic(
                              color: ColorManager.paper400,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

