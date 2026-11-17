import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/helpers/direction_extension.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_cached_network_image.dart';
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
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            decoration: BoxDecoration(
              color: ColorManager.primaryLight.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: ColorManager.gold.withValues(alpha: 0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // 1. Natural Height Image (Displays 100% of the image without forcing or stretching)
                AppCachedNetworkImage(
                  imageUrl: ambassador.imageUrl,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                  memCacheWidth: 800,
                ),

                // 2. Dark vignette overlay at the bottom for typography legibility
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 120.h,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          ColorManager.primaryDark.withValues(alpha: 0.65),
                          ColorManager.primaryDark.withValues(alpha: 0.95),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // 3. Chevron navigation pill
                PositionedDirectional(
                  start: 14.w,
                  top: 14.h,
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: ColorManager.primaryDark.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorManager.gold.withValues(alpha: 0.3),
                        width: 0.8,
                      ),
                    ),
                    child: Icon(
                      context.forwardChevron,
                      color: ColorManager.goldLight,
                      size: 16.sp,
                    ),
                  ),
                ),

                // 4. Content Info positioned gracefully over the bottom gradient
                Positioned(
                  bottom: 14.h,
                  left: 16.w,
                  right: 16.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ambassador.name,
                        style: AppFonts.alexandria(
                          color: ColorManager.paper100,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (ambassador.shortDescription.isNotEmpty) ...[
                        SizedBox(height: 3.h),
                        Text(
                          ambassador.shortDescription,
                          style: AppFonts.ibmPlexSansArabic(
                            color: ColorManager.goldLight,
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (ambassador.followersCount > 0) ...[
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Icon(
                              Icons.people_outline_rounded,
                              size: 13.sp,
                              color: ColorManager.paper400,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'ambassadors.followers_count'.tr(
                                args: ['${ambassador.followersCount}'],
                              ),
                              style: AppFonts.ibmPlexSansArabic(
                                color: ColorManager.paper400,
                                fontSize: 10.5.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
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
