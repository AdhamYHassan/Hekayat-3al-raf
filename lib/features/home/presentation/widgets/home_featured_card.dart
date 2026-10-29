import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_story_entity.dart';

class HomeFeaturedCard extends StatelessWidget {
  final FeaturedStoryEntity featured;
  final VoidCallback onTap;

  const HomeFeaturedCard({
    super.key,
    required this.featured,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final story = featured.story;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              height: 224.h,
              decoration: BoxDecoration(
                color: ColorManager.primaryLight,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      story.coverImageUrl,
                      fit: BoxFit.cover,
                      alignment: const Alignment(0.0, -0.3),
                      cacheWidth: 350 * 2,
                      errorBuilder: (context, error, stackTrace) => Container(color: ColorManager.primaryLight),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color(0x50220610),
                            Color(0xF0220610),
                          ],
                        ),
                      ),
                    ),
                    // Format Tag Top Right
                    Positioned(
                      top: 12.h,
                      right: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: ColorManager.primaryLight.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(CupertinoIcons.headphones, size: 12.sp, color: ColorManager.goldLight),
                            SizedBox(width: 4.w),
                            Text(
                              'صوتية',
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: ColorManager.goldLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Bottom Story Info
                    Positioned(
                      bottom: 12.h,
                      left: 14.w,
                      right: 14.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story.category,
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorManager.gold,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            story.title,
                            style: GoogleFonts.alexandria(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorManager.paper100,
                              height: 1.25,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            story.excerpt,
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 12.sp,
                              color: ColorManager.paper200.withValues(alpha: 0.7),
                              height: 1.45,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Icon(CupertinoIcons.eye, size: 13.sp, color: ColorManager.paper400),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '٤٨٫٢ ألف',
                                    style: GoogleFonts.ibmPlexSansArabic(
                                      fontSize: 11.sp,
                                      color: ColorManager.paper400,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Icon(CupertinoIcons.star_fill, size: 13.sp, color: ColorManager.gold),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '٤٫٦',
                                    style: GoogleFonts.ibmPlexSansArabic(
                                      fontSize: 11.sp,
                                      color: ColorManager.paper400,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                story.authorName,
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 11.sp,
                                  color: ColorManager.paper400,
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
          SizedBox(height: 12.h),
          // Pull Quote
          Container(
            padding: EdgeInsets.only(right: 12.w, left: 8.w, top: 2.h, bottom: 2.h),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: ColorManager.gold, width: 2.5.w),
              ),
            ),
            child: Text(
              featured.pullQuote,
              style: GoogleFonts.arefRuqaa(
                fontSize: 15.sp,
                fontStyle: FontStyle.italic,
                color: ColorManager.goldLight,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
