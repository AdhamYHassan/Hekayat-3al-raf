import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/routing/routes.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/features/podcast/presentation/bloc/podcasts_list_cubit.dart';
import 'package:hekayat_3al_raf/features/podcast/presentation/bloc/podcasts_list_state.dart';
import 'package:hekayat_3al_raf/features/podcast/presentation/widgets/podcast_directory_card_item.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/widgets/story_detail_header.dart';

class PodcastsScreen extends StatelessWidget {
  const PodcastsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PodcastsListCubit>(
      create: (context) => getIt<PodcastsListCubit>()..loadPodcasts(),
      child: const _PodcastsView(),
    );
  }
}

class _PodcastsView extends StatelessWidget {
  const _PodcastsView();

  bool _onScrollNotification(
    ScrollNotification notification,
    BuildContext context,
  ) {
    if (notification is ScrollUpdateNotification) {
      final metrics = notification.metrics;
      if (metrics.pixels >= metrics.maxScrollExtent * 0.85) {
        context.read<PodcastsListCubit>().loadMorePodcasts();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            StoryDetailHeader(onBackTap: () => Navigator.of(context).pop()),
            Expanded(
              child: BlocBuilder<PodcastsListCubit, PodcastsListState>(
                builder: (context, state) {
                  if (state.status == PodcastsListStatus.loading ||
                      state.status == PodcastsListStatus.initial) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.gold,
                      ),
                    );
                  }

                  if (state.status == PodcastsListStatus.failure &&
                      state.episodes.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.errorMessage ??
                                  'podcast.details_load_error'.tr(),
                              textAlign: TextAlign.center,
                              style: AppFonts.ibmPlexSansArabic(
                                color: ColorManager.paper200,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<PodcastsListCubit>()
                                  .loadPodcasts(isRefresh: true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.gold,
                                foregroundColor: ColorManager.primaryDark,
                              ),
                              child: Text('common.retry'.tr()),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state.episodes.isEmpty) {
                    return Center(
                      child: Text(
                        'common.no_data'.tr(),
                        style: AppFonts.ibmPlexSansArabic(
                          color: ColorManager.paper200,
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (notification) =>
                        _onScrollNotification(notification, context),
                    child: RefreshIndicator(
                      color: ColorManager.gold,
                      backgroundColor: ColorManager.primaryLight,
                      onRefresh: () => context
                          .read<PodcastsListCubit>()
                          .loadPodcasts(isRefresh: true),
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        itemCount: state.episodes.length +
                            (state.isLoadingMore ? 1 : 0),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16.h),
                        itemBuilder: (context, index) {
                          if (index >= state.episodes.length) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                child: const CircularProgressIndicator(
                                  color: ColorManager.gold,
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          }

                          final episode = state.episodes[index];
                          return PodcastDirectoryCardItem(
                            episode: episode,
                            onTap: () {
                              context.push(
                                Routes.podcastDetails,
                                extra: {'id': episode.id},
                              );
                            },
                          );
                        },
                      ),
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
