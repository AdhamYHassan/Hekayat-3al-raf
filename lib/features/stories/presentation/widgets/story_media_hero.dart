import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';

enum StoryMediaType { audio, video, image }

class StoryMediaHero extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String authorInfo;
  final String category;
  final String year;
  final StoryMediaType mediaType;
  final VoidCallback onShareTap;

  const StoryMediaHero({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.authorInfo,
    required this.category,
    required this.year,
    required this.mediaType,
    required this.onShareTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 288.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            alignment: const Alignment(0.0, -0.2),
            cacheWidth: 375 * 2,
            errorBuilder: (context, error, stackTrace) => Container(color: ColorManager.primaryLight),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x66220610),
                  Color(0x4D220610),
                  Color(0xFF220610),
                ],
              ),
            ),
          ),
          Positioned(
            top: 12.h,
            left: 12.w,
            child: InkWell(
              onTap: onShareTap,
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: ColorManager.primaryDark.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                  border: Border.all(color: ColorManager.gold.withValues(alpha: 0.3)),
                ),
                child: Icon(CupertinoIcons.share, size: 16.sp, color: ColorManager.gold),
              ),
            ),
          ),
          Positioned(
            bottom: 16.h,
            left: 16.w,
            right: 16.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: ColorManager.primaryLight.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            mediaType == StoryMediaType.audio
                                ? CupertinoIcons.headphones
                                : (mediaType == StoryMediaType.video
                                    ? CupertinoIcons.video_camera_solid
                                    : CupertinoIcons.photo),
                            size: 11.sp,
                            color: ColorManager.goldLight,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            mediaType == StoryMediaType.audio
                                ? 'صوتية'
                                : (mediaType == StoryMediaType.video ? 'مرئية' : 'مصورة'),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorManager.goldLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(category, style: GoogleFonts.ibmPlexSansArabic(fontSize: 11.sp, color: ColorManager.paper200)),
                    SizedBox(width: 4.w),
                    Text('· $year', style: GoogleFonts.ibmPlexSansArabic(fontSize: 11.sp, color: ColorManager.paper400)),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  title,
                  style: GoogleFonts.alexandria(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorManager.paper100,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(authorInfo, style: GoogleFonts.ibmPlexSansArabic(fontSize: 12.sp, color: ColorManager.paper200.withValues(alpha: 0.7))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

