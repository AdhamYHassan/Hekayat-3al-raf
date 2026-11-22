import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/routing/routes.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_cached_network_image.dart';
import 'package:hekayat_3al_raf/features/podcast/domain/entities/podcast_details_entity.dart';
import 'package:hekayat_3al_raf/features/podcast/presentation/bloc/podcast_details_cubit.dart';
import 'package:hekayat_3al_raf/features/podcast/presentation/bloc/podcast_details_state.dart';
import 'package:hekayat_3al_raf/features/podcast/presentation/widgets/podcast_smart_video_player_card.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/widgets/story_detail_header.dart';

class PodcastDetailsScreen extends StatelessWidget {
  final int podcastId;

  const PodcastDetailsScreen({
    super.key,
    required this.podcastId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PodcastDetailsCubit>(
      create: (context) =>
          getIt<PodcastDetailsCubit>()..loadPodcastDetails(podcastId),
      child: const _PodcastDetailsView(),
    );
  }
}

class _PodcastDetailsView extends StatelessWidget {
  const _PodcastDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Local Logo and Back Button
            StoryDetailHeader(onBackTap: () => Navigator.of(context).pop()),
            Expanded(
              child: BlocBuilder<PodcastDetailsCubit, PodcastDetailsState>(
                builder: (context, state) {
                  if (state.status == PodcastDetailsStatus.loading ||
                      state.status == PodcastDetailsStatus.initial) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.gold,
                      ),
                    );
                  }

                  if (state.status == PodcastDetailsStatus.failure ||
                      state.podcast == null) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          state.errorMessage ?? 'podcast.details_load_error'.tr(),
                          textAlign: TextAlign.center,
                          style: AppFonts.ibmPlexSansArabic(
                            color: ColorManager.paper200,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    );
                  }

                  final podcast = state.podcast!;
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Episode Badge & Number
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: ColorManager.gold.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: ColorManager.goldLight.withValues(alpha: 0.5),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                '${'podcast.tag'.tr()} #${podcast.number}',
                                style: AppFonts.alexandria(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorManager.goldLight,
                                ),
                              ),
                            ),
                            if (podcast.publishedOn.isNotEmpty) ...[
                              SizedBox(width: 8.w),
                              Icon(
                                CupertinoIcons.calendar,
                                size: 12.sp,
                                color: ColorManager.paper400,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                podcast.publishedOn,
                                style: AppFonts.ibmPlexSansArabic(
                                  fontSize: 11.sp,
                                  color: ColorManager.paper400,
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 12.h),

                        // 2. Title
                        Text(
                          podcast.title,
                          style: AppFonts.alexandria(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorManager.paper100,
                            height: 1.35,
                          ),
                        ),

                        if (podcast.guest.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.person_crop_circle_fill,
                                size: 14.sp,
                                color: ColorManager.goldLight,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                '${'podcast.guest_label'.tr()}: ${podcast.guest}',
                                style: AppFonts.ibmPlexSansArabic(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorManager.goldLight,
                                ),
                              ),
                            ],
                          ),
                        ],

                        SizedBox(height: 16.h),

                        // 3. Smart Video Player Surface
                        PodcastSmartVideoPlayerCard(
                          videoUrl: podcast.videoUrl,
                          embedSrc: podcast.embedSrc,
                          title: podcast.title,
                          thumbnailUrl: podcast.imageUrl,
                        ),

                        SizedBox(height: 16.h),

                        // 4. Description Box
                        if (podcast.description.isNotEmpty) ...[
                          Text(
                            'podcast.about_episode'.tr(),
                            style: AppFonts.alexandria(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorManager.paper100,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(14.w),
                            decoration: BoxDecoration(
                              color: ColorManager.primaryLight,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: ColorManager.goldLight.withValues(alpha: 0.15),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              podcast.description,
                              style: AppFonts.ibmPlexSansArabic(
                                fontSize: 13.sp,
                                color: ColorManager.paper200,
                                height: 1.7,
                              ),
                            ),
                          ),
                        ],

                        // 5. More Episodes (if present in API response)
                        if (podcast.moreEpisodes.isNotEmpty) ...[
                          SizedBox(height: 24.h),
                          Text(
                            'podcast.more_episodes'.tr(),
                            style: AppFonts.alexandria(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorManager.paper100,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: podcast.moreEpisodes.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 10.h),
                            itemBuilder: (context, index) {
                              final item = podcast.moreEpisodes[index];
                              return _MoreEpisodeCard(
                                episode: item,
                                onTap: () {
                                  context.push(
                                    Routes.podcastDetails,
                                    extra: {'id': item.id},
                                  );
                                },
                              );
                            },
                          ),
                        ],

                        SizedBox(height: 24.h),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreEpisodeCard extends StatelessWidget {
  final PodcastEpisodeEntitySummary episode;
  final VoidCallback onTap;

  const _MoreEpisodeCard({
    required this.episode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: ColorManager.primaryLight,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: SizedBox(
                width: 90.w,
                height: 60.h,
                child: AppCachedNetworkImage(
                  imageUrl: episode.imageUrl,
                  fit: BoxFit.cover,
                  memCacheWidth: 180,
                  memCacheHeight: 120,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.title,
                    style: AppFonts.alexandria(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorManager.paper100,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (episode.guest.isNotEmpty) ...[
                    SizedBox(height: 4.h),
                    Text(
                      episode.guest,
                      style: AppFonts.ibmPlexSansArabic(
                        fontSize: 11.sp,
                        color: ColorManager.goldLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_back,
              size: 14.sp,
              color: ColorManager.paper400,
            ),
          ],
        ),
      ),
    );
  }
}
