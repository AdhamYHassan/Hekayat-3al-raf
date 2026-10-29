import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';

class HomeAmbassadorsList extends StatelessWidget {
  final List<AmbassadorFeedItem> ambassadors;
  final ValueChanged<AmbassadorFeedItem> onAmbassadorTap;

  const HomeAmbassadorsList({
    super.key,
    required this.ambassadors,
    required this.onAmbassadorTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 144.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: ambassadors.length,
        separatorBuilder: (context, index) => SizedBox(width: 14.w),
        itemBuilder: (context, index) {
          final ambassador = ambassadors[index];
          return InkWell(
            onTap: () => onAmbassadorTap(ambassador),
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              width: 140.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  color: ColorManager.primaryLight,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        ambassador.portraitUrl,
                        fit: BoxFit.cover,
                        alignment: const Alignment(0.0, -0.56),
                        cacheWidth: 140 * 2,
                        errorBuilder: (context, error, stackTrace) => Container(color: ColorManager.primaryLight),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Color(0xE6220610),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8.h,
                        left: 8.w,
                        right: 8.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ambassador.name,
                              style: GoogleFonts.alexandria(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: ColorManager.paper100,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              ambassador.role,
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 10.sp,
                                color: ColorManager.goldLight,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
        },
      ),
    );
  }
}
