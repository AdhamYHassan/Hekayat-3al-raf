import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/stories/domain/entities/story_details_entity.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/bloc/story_details_cubit.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/bloc/story_details_state.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/widgets/story_detail_header.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/widgets/story_details_shimmer_loading.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/widgets/story_document_card.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/widgets/story_media_hero.dart'
    as hero;
import 'package:hekayat_3al_raf/features/stories/presentation/widgets/story_player_card.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/widgets/story_rating_section.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/widgets/story_video_player_card.dart';

class StoryDetailsScreen extends StatelessWidget {
  final String storyId;

  const StoryDetailsScreen({
    super.key,
    required this.storyId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StoryDetailsCubit>(
      create: (context) => getIt<StoryDetailsCubit>()..loadStoryDetails(storyId),
      child: const _StoryDetailsView(),
    );
  }
}

class _StoryDetailsView extends StatelessWidget {
  const _StoryDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Bar with Brand Logo and Back button
            StoryDetailHeader(onBackTap: () => Navigator.of(context).pop()),

            // 2. Body State
            Expanded(
              child: BlocBuilder<StoryDetailsCubit, StoryDetailsState>(
                builder: (context, state) {
                  if (state.status == StoryDetailsStatus.loading ||
                      state.status == StoryDetailsStatus.initial) {
                    return const StoryDetailsShimmerLoading();
                  }

                  if (state.status == StoryDetailsStatus.failure || state.story == null) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          state.errorMessage ?? 'تعذر تحميل تفاصيل الحكاية',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ibmPlexSansArabic(
                            color: ColorManager.paper200,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    );
                  }

                  final story = state.story!;
                  final media = story.media;

                  return ListView(
                    padding: EdgeInsets.only(bottom: 40.h),
                    children: [
                      // Hero Cover & Header info
                      hero.StoryMediaHero(
                        imageUrl: story.coverImage,
                        title: story.title,
                        authorInfo: '${story.authorName} · ${story.submissionTypeLabel}',
                        category: story.submissionTypeLabel,
                        year: story.publishedAt.split('-').first,
                        mediaType: switch (story.mediaType) {
                          StoryMediaType.audio => hero.StoryMediaType.audio,
                          StoryMediaType.video => hero.StoryMediaType.video,
                          _ => hero.StoryMediaType.image,
                        },
                        onShareTap: () {},
                      ),

                      // Stats bar
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  CupertinoIcons.eye,
                                  size: 14.sp,
                                  color: ColorManager.paper400,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  story.viewsCount >= 1000
                                      ? '${(story.viewsCount / 1000).toStringAsFixed(1)} ألف'
                                      : '${story.viewsCount}',
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 12.sp,
                                    color: ColorManager.paper200,
                                  ),
                                ),
                                SizedBox(width: 14.w),
                                Icon(
                                  CupertinoIcons.heart_fill,
                                  size: 14.sp,
                                  color: ColorManager.gold,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '${story.likes}',
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 12.sp,
                                    color: ColorManager.paper200,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: ColorManager.primaryLight.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                story.submissionTypeLabel,
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 11.sp,
                                  color: ColorManager.goldLight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Dynamic Media Player based on API response:
                      if (story.mediaType == StoryMediaType.video &&
                          media.video != null &&
                          media.video!.isNotEmpty) ...[
                        StoryVideoPlayerCard(
                          title: story.title,
                          videoUrl: media.video!,
                        ),
                        SizedBox(height: 16.h),
                      ] else if (story.mediaType == StoryMediaType.audio &&
                          media.audio != null &&
                          media.audio!.isNotEmpty) ...[
                        StoryPlayerCard(
                          mediaType: hero.StoryMediaType.audio,
                          title: story.title,
                          audioUrl: media.audio!,
                          narrator: story.authorName,
                          category: story.submissionTypeLabel,
                          artworkUrl: story.coverImage,
                        ),
                        SizedBox(height: 16.h),
                      ] else if (story.mediaType == StoryMediaType.document &&
                          media.document != null &&
                          media.document!.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: StoryDocumentCard(
                            title: story.title,
                            documentUrl: media.document!,
                            documentKey: story.id,
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],

                      // Narrative body paragraphs
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              story.summary,
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorManager.paper100,
                                height: 1.8,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              story.body,
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 13.5.sp,
                                color: ColorManager.paper200.withValues(alpha: 0.8),
                                height: 1.9,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Rating & Voting Section
                      const StoryRatingSection(),
                    ],
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
