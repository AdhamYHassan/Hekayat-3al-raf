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
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';
import 'package:hekayat_3al_raf/features/moments/presentation/bloc/moment_details_cubit.dart';
import 'package:hekayat_3al_raf/features/moments/presentation/bloc/moment_details_state.dart';
import 'package:hekayat_3al_raf/features/podcast/presentation/widgets/podcast_smart_video_player_card.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/widgets/story_detail_header.dart';

class MomentDetailsScreen extends StatelessWidget {
  final int momentId;

  const MomentDetailsScreen({super.key, required this.momentId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MomentDetailsCubit>(
      create: (context) =>
          getIt<MomentDetailsCubit>()..loadMomentDetails(momentId),
      child: const _MomentDetailsView(),
    );
  }
}

class _MomentDetailsView extends StatelessWidget {
  const _MomentDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            StoryDetailHeader(onBackTap: () => Navigator.of(context).pop()),
            Expanded(
              child: BlocBuilder<MomentDetailsCubit, MomentDetailsState>(
                builder: (context, state) {
                  if (state.status == MomentDetailsStatus.loading ||
                      state.status == MomentDetailsStatus.initial) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.gold,
                      ),
                    );
                  }

                  if (state.status == MomentDetailsStatus.failure ||
                      state.moment == null) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          state.errorMessage ?? 'common.server_error'.tr(),
                          textAlign: TextAlign.center,
                          style: AppFonts.ibmPlexSansArabic(
                            color: ColorManager.paper200,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    );
                  }

                  final moment = state.moment!;
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Kind Badge & Created date
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: ColorManager.gold.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: ColorManager.goldLight.withValues(
                                    alpha: 0.5,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                moment.kind == MomentKind.video
                                    ? 'moments.kind_video'.tr()
                                    : 'moments.kind_photo'.tr(),
                                style: AppFonts.alexandria(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorManager.goldLight,
                                ),
                              ),
                            ),
                            if (moment.created.isNotEmpty) ...[
                              SizedBox(width: 8.w),
                              Icon(
                                CupertinoIcons.calendar,
                                size: 12.sp,
                                color: ColorManager.paper400,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                moment.created.split('T').first,
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
                          moment.title,
                          style: AppFonts.alexandria(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorManager.paper100,
                            height: 1.35,
                          ),
                        ),

                        SizedBox(height: 14.h),

                        // 3. Media Card (Smart Video Player if video, or tap-to-fullscreen if photo)
                        if (moment.kind == MomentKind.video &&
                            moment.videoUrl != null &&
                            moment.videoUrl!.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(bottom: 4.h),
                            child: PodcastSmartVideoPlayerCard(
                              videoUrl: moment.videoUrl!,
                              title: moment.title,
                              thumbnailUrl: moment.imageUrl ?? '',
                            ),
                          )
                        else
                          InkWell(
                            onTap: () {
                              // Open interactive full screen viewer
                              final feedItem = MomentFeedItemEntity(
                                id: moment.id,
                                kind: moment.kind,
                                title: moment.title,
                                description: moment.description,
                                imageUrl: moment.imageUrl,
                                videoUrl: moment.videoUrl,
                                webUrl: moment.webUrl,
                                created: moment.created,
                              );
                              context.push(
                                Routes.momentViewer,
                                extra: {
                                  'moments': [feedItem],
                                  'initialIndex': 0,
                                },
                              );
                            },
                            borderRadius: BorderRadius.circular(12.r),
                            child: Container(
                              height: 260.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: ColorManager.primaryLight,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: ColorManager.goldLight.withValues(
                                    alpha: 0.4,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(11.r),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    if (moment.imageUrl != null &&
                                        moment.imageUrl!.isNotEmpty)
                                      AppCachedNetworkImage(
                                        imageUrl: moment.imageUrl!,
                                        fit: BoxFit.cover,
                                        memCacheWidth: 720,
                                        memCacheHeight: 520,
                                      )
                                    else
                                      const Center(
                                        child: Icon(
                                          CupertinoIcons.photo,
                                          size: 48,
                                          color: ColorManager.paper400,
                                        ),
                                      ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Color(0x99220610),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 14.w,
                                          vertical: 8.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(
                                            alpha: 0.6,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                          border: Border.all(
                                            color: ColorManager.goldLight,
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              CupertinoIcons.viewfinder,
                                              size: 14.sp,
                                              color: ColorManager.goldLight,
                                            ),
                                            SizedBox(width: 6.w),
                                            Text(
                                              'moments.tap_to_view_fullscreen'
                                                  .tr(),
                                              style: AppFonts.alexandria(
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.w600,
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
                          ),

                        // 4. Description Box
                        if (moment.description.isNotEmpty) ...[
                          SizedBox(height: 16.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(14.w),
                            decoration: BoxDecoration(
                              color: ColorManager.primaryLight,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: ColorManager.goldLight.withValues(
                                  alpha: 0.15,
                                ),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              moment.description,
                              style: AppFonts.ibmPlexSansArabic(
                                fontSize: 13.sp,
                                color: ColorManager.paper200,
                                height: 1.7,
                              ),
                            ),
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
