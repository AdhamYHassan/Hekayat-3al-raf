import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/routing/routes.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_cached_network_image.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/my_story_entity.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/bloc/my_stories_cubit.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/bloc/my_stories_state.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/widgets/my_stories_shimmer_loading.dart';

class MyStoriesScreen extends StatelessWidget {
  const MyStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryDark,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            // Top App Bar matching prototype header
            _buildAppBar(context),

            // Content
            Expanded(
              child: BlocBuilder<MyStoriesCubit, MyStoriesState>(
                builder: (context, state) {
                  return switch (state) {
                    MyStoriesInitial() || MyStoriesLoading() =>
                      const SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: MyStoriesShimmerLoading(),
                      ),
                    MyStoriesError(:final message) => Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.r),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.exclamationmark_circle,
                                color: ColorManager.gold,
                                size: 48.sp,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                message,
                                textAlign: TextAlign.center,
                                style: AppFonts.ibmPlexSansArabic(
                                  color: ColorManager.paper200,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              ElevatedButton(
                                onPressed: () =>
                                    context.read<MyStoriesCubit>().loadMyStories(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorManager.gold,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.r),
                                  ),
                                ),
                                child: Text(
                                  'common.retry'.tr(),
                                  style: AppFonts.alexandria(
                                    color: ColorManager.primaryDark,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    MyStoriesLoaded(
                      :final stories,
                      :final totalCount,
                      :final inReviewCount,
                      :final publishedCount,
                    ) =>
                      _MyStoriesContent(
                        stories: stories,
                        totalCount: totalCount,
                        inReviewCount: inReviewCount,
                        publishedCount: publishedCount,
                      ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: ColorManager.primaryDark.withValues(alpha: 0.95),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 6.h,
        bottom: 10.h,
        left: 16.w,
        right: 16.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppCachedNetworkImage(
            imageUrl: 'https://hekayat-ala-el-raff-m9tr.bolt.host/brand/logo-gold.webp',
            height: 32.h,
            fit: BoxFit.contain,
            memCacheHeight: 90,
            errorWidget: Text(
              'app_name'.tr(),
              style: AppFonts.arefRuqaa(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: ColorManager.gold,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'common.back'.tr(),
                    style: AppFonts.ibmPlexSansArabic(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: ColorManager.goldLight,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.chevron_left_rounded,
                    color: ColorManager.goldLight,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MyStoriesContent extends StatelessWidget {
  final List<MyStoryEntity> stories;
  final int totalCount;
  final int inReviewCount;
  final int publishedCount;

  const _MyStoriesContent({
    required this.stories,
    required this.totalCount,
    required this.inReviewCount,
    required this.publishedCount,
  });

  String _formatDate(BuildContext context, DateTime? date) {
    if (date == null) return '—';
    final isAr = context.locale.languageCode == 'ar';
    final formatter = DateFormat('d MMMM yyyy', isAr ? 'ar' : 'en');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Navigation Breadcrumb & Page Title
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chevron_right_rounded,
                        color: ColorManager.goldLight.withValues(alpha: 0.75),
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'profile.my_stories_screen.back_to_profile'.tr(),
                        style: AppFonts.ibmPlexSansArabic(
                          fontSize: 12.5.sp,
                          color: ColorManager.goldLight.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),

                // Kicker with Gold Bar
                Row(
                  children: [
                    Container(width: 20.w, height: 1.5.h, color: ColorManager.gold),
                    SizedBox(width: 8.w),
                    Text(
                      'profile.my_stories_screen.kicker'.tr(),
                      style: AppFonts.ibmPlexSansArabic(
                        color: ColorManager.gold,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),

                // Page Heading
                Text(
                  'profile.my_stories_screen.title'.tr(),
                  style: AppFonts.alexandria(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.paper100,
                  ),
                ),
              ],
            ),
          ),

          // 2. Three Counter Metric Badges
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                // All Count
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: ColorManager.primaryLight.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: ColorManager.gold.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$totalCount',
                          style: AppFonts.alexandria(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.paper100,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'profile.my_stories_screen.stat_all'.tr(),
                          style: AppFonts.ibmPlexSansArabic(
                            fontSize: 11.sp,
                            color: ColorManager.paper400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),

                // In Review Count
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: ColorManager.gold.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: ColorManager.gold.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$inReviewCount',
                          style: AppFonts.alexandria(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorManager.gold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'profile.my_stories_screen.stat_in_review'.tr(),
                          style: AppFonts.ibmPlexSansArabic(
                            fontSize: 11.sp,
                            color: ColorManager.paper400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),

                // Published Count
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: const Color(0xFF10B981).withValues(alpha: 0.25),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$publishedCount',
                          style: AppFonts.alexandria(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF34D399),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'profile.my_stories_screen.stat_published'.tr(),
                          style: AppFonts.ibmPlexSansArabic(
                            fontSize: 11.sp,
                            color: ColorManager.paper400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),

          // 3. Story Cards List
          if (stories.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.h),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      CupertinoIcons.book,
                      size: 54.sp,
                      color: ColorManager.gold.withValues(alpha: 0.4),
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      'profile.my_stories_screen.empty_title'.tr(),
                      style: AppFonts.alexandria(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.paper100,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'profile.my_stories_screen.empty_subtitle'.tr(),
                      textAlign: TextAlign.center,
                      style: AppFonts.ibmPlexSansArabic(
                        fontSize: 12.5.sp,
                        color: ColorManager.paper400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: stories.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final story = stories[index];
                  return _MyStoryCard(
                    story: story,
                    formattedDate: _formatDate(context, story.created),
                    onTap: () {
                      if (story.isPublished) {
                        context.push(
                          Routes.storyDetails,
                          extra: {'id': story.id},
                        );
                      }
                    },
                  );
                },
              ),
            ),

          SizedBox(height: 24.h),

          // 4. "احكي حكاية جديدة" CTA Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SizedBox(
              width: double.infinity,
              child: InkWell(
                onTap: () {
                  context.push(Routes.home); // or directly open submit tab
                },
                borderRadius: BorderRadius.circular(30.r),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE8CB7D), Color(0xFFC9A24B)],
                    ),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  child: Center(
                    child: Text(
                      'profile.my_stories_screen.tell_new_story'.tr(),
                      style: AppFonts.alexandria(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.primaryDark,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 60.h),
        ],
      ),
    );
  }
}

class _MyStoryCard extends StatelessWidget {
  final MyStoryEntity story;
  final String formattedDate;
  final VoidCallback onTap;

  const _MyStoryCard({
    required this.story,
    required this.formattedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPublished = story.isPublished;
    final isRejected = story.statusLabel.contains('مرفوض');

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: ColorManager.primaryLight.withValues(alpha: 0.30),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: ColorManager.gold.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail / Cover image
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                width: 80.r,
                height: 80.r,
                color: ColorManager.primaryLight,
                child: story.thumbnail != null && story.thumbnail!.isNotEmpty
                    ? AppCachedNetworkImage(
                        imageUrl: story.thumbnail!,
                        fit: BoxFit.cover,
                        width: 80.r,
                        height: 80.r,
                        memCacheWidth: 200,
                        memCacheHeight: 200,
                        errorWidget: _buildFallbackImage(),
                      )
                    : _buildFallbackImage(),
              ),
            ),
            SizedBox(width: 12.w),

            // Story Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges: Submission Type + Status
                  Row(
                    children: [
                      // Format Tag
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorManager.primaryDark.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getFormatIcon(story.submissionType),
                              size: 11.sp,
                              color: ColorManager.goldLight,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              story.submissionTypeLabel,
                              style: AppFonts.ibmPlexSansArabic(
                                fontSize: 10.sp,
                                color: ColorManager.goldLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 6.w),

                      // Status Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: isPublished
                              ? const Color(0xFF10B981).withValues(alpha: 0.15)
                              : isRejected
                                  ? const Color(0xFFEF4444).withValues(alpha: 0.15)
                                  : ColorManager.gold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isPublished
                                ? const Color(0xFF10B981).withValues(alpha: 0.3)
                                : isRejected
                                    ? const Color(0xFFEF4444).withValues(alpha: 0.3)
                                    : ColorManager.gold.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPublished
                                  ? CupertinoIcons.checkmark_circle_fill
                                  : isRejected
                                      ? CupertinoIcons.xmark_circle_fill
                                      : CupertinoIcons.clock,
                              size: 11.sp,
                              color: isPublished
                                  ? const Color(0xFF34D399)
                                  : isRejected
                                      ? const Color(0xFFF87171)
                                      : ColorManager.gold,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              story.statusLabel,
                              style: AppFonts.ibmPlexSansArabic(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: isPublished
                                    ? const Color(0xFF34D399)
                                    : isRejected
                                        ? const Color(0xFFF87171)
                                        : ColorManager.gold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  // Title
                  Text(
                    story.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.alexandria(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.paper100,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Date Created
                  Text(
                    formattedDate,
                    style: AppFonts.ibmPlexSansArabic(
                      fontSize: 11.sp,
                      color: ColorManager.paper400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFormatIcon(String type) {
    return switch (type.toLowerCase()) {
      'text' => CupertinoIcons.book,
      'audio' => CupertinoIcons.headphones,
      'video' => CupertinoIcons.videocam,
      'document' => CupertinoIcons.doc_text,
      _ => CupertinoIcons.doc_text,
    };
  }

  Widget _buildFallbackImage() {
    return Container(
      color: ColorManager.primaryLight,
      child: Center(
        child: Icon(
          CupertinoIcons.photo,
          color: ColorManager.gold.withValues(alpha: 0.5),
          size: 28.sp,
        ),
      ),
    );
  }
}

