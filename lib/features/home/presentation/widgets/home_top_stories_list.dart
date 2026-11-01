import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_story_entity.dart';

class HomeTopStoriesList extends StatelessWidget {
  final List<StoryFeedItem> stories;
  final ValueChanged<StoryFeedItem> onStoryTap;

  const HomeTopStoriesList({
    super.key,
    required this.stories,
    required this.onStoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final story = stories[index];
          return InkWell(
            onTap: () => onStoryTap(story),
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              width: 180.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 128.h,
                    decoration: BoxDecoration(
                      color: ColorManager.primaryLight,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            story.coverImageUrl,
                            fit: BoxFit.cover,
                            cacheWidth: 180 * 2,
                            errorBuilder: (context, error, stackTrace) => Container(color: ColorManager.primaryLight),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Color(0xCC220610),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8.h,
                            right: 8.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: ColorManager.primaryLight.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    switch (story.contentType) {
                                      StoryContentType.audio => CupertinoIcons.headphones,
                                      StoryContentType.video => CupertinoIcons.video_camera_solid,
                                      StoryContentType.document => CupertinoIcons.doc_text,
                                      StoryContentType.text => CupertinoIcons.book,
                                    },
                                    size: 10.sp,
                                    color: ColorManager.goldLight,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    story.submissionTypeLabel.isNotEmpty
                                        ? story.submissionTypeLabel
                                        : (story.contentType == StoryContentType.audio
                                            ? 'صوتية'
                                            : (story.contentType == StoryContentType.video
                                                ? 'مصورة'
                                                : 'مكتوبة')),
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    story.title,
                    style: GoogleFonts.alexandria(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorManager.paper100,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(CupertinoIcons.eye, size: 12.sp, color: ColorManager.paper400),
                      SizedBox(width: 3.w),
                      Text(
                        story.viewsCount >= 1000
                            ? '${(story.viewsCount / 1000).toStringAsFixed(1)} ألف'
                            : '${story.viewsCount}',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 11.sp,
                          color: ColorManager.paper400,
                        ),
                      ),
                      if (story.rating != null) ...[
                        SizedBox(width: 8.w),
                        Icon(CupertinoIcons.star_fill, size: 12.sp, color: ColorManager.gold),
                        SizedBox(width: 3.w),
                        Text(
                          '${story.rating}',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11.sp,
                            color: ColorManager.paper400,
                          ),
                        ),
                      ] else if (story.likes > 0) ...[
                        SizedBox(width: 8.w),
                        Icon(CupertinoIcons.heart_fill, size: 12.sp, color: ColorManager.gold),
                        SizedBox(width: 3.w),
                        Text(
                          '${story.likes}',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11.sp,
                            color: ColorManager.paper400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
