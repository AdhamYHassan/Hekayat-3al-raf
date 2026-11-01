import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theming/colors_manager.dart';

/// Supported story submission types matching backend schema & prototype DOM
enum StoryCardMediaType { text, audio, video, document }

/// Atomic UI item representing a single story card in the stories directory
class StoryCardItem extends StatelessWidget {
  final String id;
  final String title;
  final String summary;
  final String authorName;
  final String city;
  final String coverImageUrl;
  final String submissionTypeLabel;
  final StoryCardMediaType mediaType;
  final String category;
  final String viewsFormatted;
  final String ratingFormatted;
  final VoidCallback onTap;

  const StoryCardItem({
    super.key,
    required this.id,
    required this.title,
    required this.summary,
    required this.authorName,
    required this.city,
    required this.coverImageUrl,
    required this.submissionTypeLabel,
    required this.mediaType,
    required this.category,
    required this.viewsFormatted,
    required this.ratingFormatted,
    required this.onTap,
  });

  IconData _getMediaIcon() {
    return switch (mediaType) {
      StoryCardMediaType.text => CupertinoIcons.book_fill,
      StoryCardMediaType.audio => CupertinoIcons.headphones,
      StoryCardMediaType.video => CupertinoIcons.videocam_fill,
      StoryCardMediaType.document => CupertinoIcons.doc_text_fill,
    };
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: ColorManager.primary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: ColorManager.gold.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Thumbnail with rounded borders & dark overlay
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: SizedBox(
                width: 96.w,
                height: 96.h,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      coverImageUrl,
                      fit: BoxFit.cover,
                      cacheWidth: 200,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: ColorManager.primaryLight,
                        child: const Icon(CupertinoIcons.photo, color: ColorManager.paper400),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            ColorManager.primaryDark.withValues(alpha: 0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(width: 12.w),

            // 2. Story Meta, Title, Excerpt & Stats
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges (Format + Category)
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: ColorManager.primaryLight.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getMediaIcon(),
                              size: 11.sp,
                              color: ColorManager.goldLight,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              submissionTypeLabel,
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: ColorManager.goldLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (category.isNotEmpty) ...[
                        SizedBox(width: 6.w),
                        Text(
                          category,
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 10.sp,
                            color: ColorManager.paper400,
                          ),
                        ),
                      ],
                    ],
                  ),

                  SizedBox(height: 6.h),

                  // Title (Alexandria bold, max 2 lines)
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.alexandria(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.paper100,
                      height: 1.3,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Summary Excerpt (max 2 lines)
                  Text(
                    summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 11.sp,
                      color: ColorManager.paper200.withValues(alpha: 0.65),
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Author, City & Engagement Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '$authorName · $city',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 10.sp,
                            color: ColorManager.paper400,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.eye, size: 13.sp, color: ColorManager.paper400),
                          SizedBox(width: 3.w),
                          Text(
                            viewsFormatted,
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 10.sp,
                              color: ColorManager.paper400,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(CupertinoIcons.star_fill, size: 12.sp, color: ColorManager.gold),
                          SizedBox(width: 2.w),
                          Text(
                            ratingFormatted,
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.paper100,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
