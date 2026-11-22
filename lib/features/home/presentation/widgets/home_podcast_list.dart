import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_cached_network_image.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';

/// Horizontal list of podcast episodes styled identically to [HomeTopStoriesList].
class HomePodcastList extends StatelessWidget {
  final List<PodcastEpisodeEntity> episodes;
  final ValueChanged<PodcastEpisodeEntity> onEpisodeTap;

  const HomePodcastList({
    super.key,
    required this.episodes,
    required this.onEpisodeTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: episodes.length,
        separatorBuilder: (context, index) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final episode = episodes[index];
          return InkWell(
            onTap: () => onEpisodeTap(episode),
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
                          AppCachedNetworkImage(
                            imageUrl: episode.imageUrl,
                            fit: BoxFit.cover,
                            memCacheWidth: 360,
                            memCacheHeight: 256,
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
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: ColorManager.primaryLight
                                    .withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    CupertinoIcons.play_circle_fill,
                                    size: 10.sp,
                                    color: ColorManager.goldLight,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'home.podcast_tag'.tr(),
                                    style: AppFonts.ibmPlexSansArabic(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                      color: ColorManager.goldLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: ColorManager.goldLight.withValues(alpha: 0.8),
                                  width: 1.2,
                                ),
                              ),
                              child: Icon(
                                CupertinoIcons.play_fill,
                                size: 18.sp,
                                color: ColorManager.goldLight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    episode.title,
                    style: AppFonts.alexandria(
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
                      Icon(
                        CupertinoIcons.person_fill,
                        size: 12.sp,
                        color: ColorManager.paper400,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          episode.guest.isNotEmpty
                              ? episode.guest
                              : episode.shortDescription,
                          style: AppFonts.ibmPlexSansArabic(
                            fontSize: 11.sp,
                            color: ColorManager.paper400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
