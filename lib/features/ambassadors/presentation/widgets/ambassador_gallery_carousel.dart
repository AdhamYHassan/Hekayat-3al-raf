import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_details_entity.dart';

class AmbassadorGalleryCarousel extends StatelessWidget {
  final List<AmbassadorGalleryItem> items;

  const AmbassadorGalleryCarousel({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                Text(
                  'ألبوم الصور والأرشيف',
                  style: GoogleFonts.alexandria(
                    color: ColorManager.paper100,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '(${items.length})',
                  style: GoogleFonts.ibmPlexSansArabic(
                    color: ColorManager.gold,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 190.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final item = items[index];
                return SizedBox(
                  width: 220.w,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorManager.primaryLight.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: ColorManager.gold.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                item.imageUrl,
                                fit: BoxFit.cover,
                                cacheWidth: 440,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(color: ColorManager.primaryLight),
                              ),
                              if (item.year != null)
                                Positioned(
                                  top: 8.h,
                                  right: 8.w,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: ColorManager.primaryDark
                                          .withValues(alpha: 0.8),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      item.year!,
                                      style: GoogleFonts.ibmPlexSansArabic(
                                        color: ColorManager.goldLight,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.w),
                          child: Text(
                            item.caption,
                            style: GoogleFonts.ibmPlexSansArabic(
                              color: ColorManager.paper200,
                              fontSize: 11.sp,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

