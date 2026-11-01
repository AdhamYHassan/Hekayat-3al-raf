import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_details_entity.dart';

class AmbassadorSelectedStoriesList extends StatelessWidget {
  final List<AmbassadorStoryItem> stories;
  final ValueChanged<AmbassadorStoryItem> onStoryTap;

  const AmbassadorSelectedStoriesList({
    super.key,
    required this.stories,
    required this.onStoryTap,
  });

  @override
  Widget build(BuildContext context) {
    if (stories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'حكايات مختارة',
            style: GoogleFonts.alexandria(
              color: ColorManager.paper100,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stories.length,
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            final story = stories[index];
            return InkWell(
              onTap: () => onStoryTap(story),
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: ColorManager.primaryLight.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: ColorManager.gold.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: ColorManager.gold.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Icon(
                          story.category.contains('صوت')
                              ? Icons.mic_rounded
                              : Icons.menu_book_rounded,
                          color: ColorManager.goldLight,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story.title,
                            style: GoogleFonts.ibmPlexSansArabic(
                              color: ColorManager.paper100,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text(
                                story.category,
                                style: GoogleFonts.ibmPlexSansArabic(
                                  color: ColorManager.goldLight,
                                  fontSize: 11.sp,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Icon(Icons.visibility_outlined,
                                  size: 13.sp, color: ColorManager.paper400),
                              SizedBox(width: 4.w),
                              Text(
                                story.viewsCount,
                                style: GoogleFonts.ibmPlexSansArabic(
                                  color: ColorManager.paper400,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14.sp,
                      color: ColorManager.goldLight.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

