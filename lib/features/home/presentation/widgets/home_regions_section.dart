import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';

class HomeRegionsSection extends StatelessWidget {
  final List<RegionArchiveItem> regions;
  final ValueChanged<RegionArchiveItem> onRegionTap;

  const HomeRegionsSection({
    super.key,
    required this.regions,
    required this.onRegionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: regions.map((region) {
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: InkWell(
              onTap: () => onRegionTap(region),
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                height: 112.h,
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
                        region.photoUrl,
                        fit: BoxFit.cover,
                        cacheWidth: 350 * 2,
                        errorBuilder: (context, error, stackTrace) => Container(color: ColorManager.primaryLight),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.transparent,
                              Color(0x66220610),
                              Color(0xE6220610),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(CupertinoIcons.arrow_left, size: 16.sp, color: ColorManager.gold),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    region.name,
                                    style: GoogleFonts.alexandria(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w700,
                                      color: ColorManager.paper100,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    region.citiesSummary,
                                    style: GoogleFonts.ibmPlexSansArabic(
                                      fontSize: 10.sp,
                                      color: ColorManager.paper200.withValues(alpha: 0.7),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    region.tagline,
                                    style: GoogleFonts.ibmPlexSansArabic(
                                      fontSize: 11.sp,
                                      color: ColorManager.goldLight,
                                    ),
                                  ),
                                ],
                              ),
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
        }).toList(),
      ),
    );
  }
}
