import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_cached_network_image.dart';
import 'package:hekayat_3al_raf/features/podcast/domain/entities/paginated_podcasts_entity.dart';

class PodcastDirectoryCardItem extends StatelessWidget {
  final PodcastDirectoryItemEntity episode;
  final VoidCallback onTap;

  const PodcastDirectoryCardItem({
    super.key,
    required this.episode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.primaryLight,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ColorManager.goldLight.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video/Cover Preview with badge & play button
            SizedBox(
              height: 180.h,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppCachedNetworkImage(
                    imageUrl: episode.imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 720,
                    memCacheHeight: 360,
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
                    top: 10.h,
                    right: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: ColorManager.primaryLight.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: ColorManager.goldLight.withValues(alpha: 0.4),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.play_circle_fill,
                            size: 11.sp,
                            color: ColorManager.goldLight,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${'podcast.tag'.tr()} #${episode.number}',
                            style: AppFonts.alexandria(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorManager.goldLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ColorManager.goldLight.withValues(alpha: 0.8),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        CupertinoIcons.play_fill,
                        size: 20.sp,
                        color: ColorManager.goldLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.title,
                    style: AppFonts.alexandria(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorManager.paper100,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),
                  if (episode.shortDescription.isNotEmpty) ...[
                    Text(
                      episode.shortDescription,
                      style: AppFonts.ibmPlexSansArabic(
                        fontSize: 12.sp,
                        color: ColorManager.paper200,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                  ],
                  Row(
                    children: [
                      if (episode.guest.isNotEmpty) ...[
                        Icon(
                          CupertinoIcons.person_crop_circle_fill,
                          size: 13.sp,
                          color: ColorManager.goldLight,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            episode.guest,
                            style: AppFonts.ibmPlexSansArabic(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: ColorManager.goldLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ] else ...[
                        const Spacer(),
                      ],
                      if (episode.publishedOn.isNotEmpty) ...[
                        Icon(
                          CupertinoIcons.calendar,
                          size: 11.sp,
                          color: ColorManager.paper400,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          episode.publishedOn,
                          style: AppFonts.ibmPlexSansArabic(
                            fontSize: 10.sp,
                            color: ColorManager.paper400,
                          ),
                        ),
                      ],
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
