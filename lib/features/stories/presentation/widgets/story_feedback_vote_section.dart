import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/bloc/story_details_cubit.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/bloc/story_details_state.dart';

/// [StoryFeedbackVoteSection] replaces the legacy star rating section with
/// an interactive dual feedback component ("وصلتك الحكاية؟").
///
/// Features:
/// 1. Granular leaf rebuild: Wrapped in [BlocSelector] watching only `(likes, dislikes, myVote)`.
/// 2. Isolated repaint boundaries: Prevents repainting the entire story article during taps.
/// 3. Zero hardcoded strings: Strictly uses easy_localization keys.
class StoryFeedbackVoteSection extends StatelessWidget {
  const StoryFeedbackVoteSection({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: ColorManager.primaryLight.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: ColorManager.gold.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          children: [
            // Title: وصلتك الحكاية؟
            Text(
              'stories.feedback_title'.tr(),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: ColorManager.paper100,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6.h),

            // Subtitle: صوتك بيخليها توصل لناس أكثر.
            Text(
              'stories.feedback_subtitle'.tr(),
              style: GoogleFonts.ibmPlexSansArabic(
                fontSize: 12.5.sp,
                color: ColorManager.paper200.withValues(alpha: 0.7),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 18.h),

            // Dual Vote Buttons with Granular Leaf State Observation
            BlocSelector<StoryDetailsCubit, StoryDetailsState, _VoteData>(
              selector: (state) {
                final story = state.story;
                return _VoteData(
                  likes: story?.likes ?? 0,
                  dislikes: story?.dislikes ?? 0,
                  myVote: story?.myVote,
                  isVotingOpen: story?.votingOpen ?? false,
                );
              },
              builder: (context, data) {
                final isLiked = data.myVote == 'like';
                final isDisliked = data.myVote == 'dislike';

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Like Button (Heart)
                    _VoteButton(
                      count: data.likes,
                      icon: isLiked
                          ? CupertinoIcons.heart_fill
                          : CupertinoIcons.heart,
                      isActive: isLiked,
                      activeColor: Colors.redAccent,
                      onTap: data.isVotingOpen
                          ? () => context
                              .read<StoryDetailsCubit>()
                              .voteStory('like')
                          : null,
                    ),
                    SizedBox(width: 14.w),

                    // Dislike Button (Thumbs Down)
                    _VoteButton(
                      count: data.dislikes,
                      icon: isDisliked
                          ? CupertinoIcons.hand_thumbsdown_fill
                          : CupertinoIcons.hand_thumbsdown,
                      isActive: isDisliked,
                      activeColor: ColorManager.gold,
                      onTap: data.isVotingOpen
                          ? () => context
                              .read<StoryDetailsCubit>()
                              .voteStory('dislike')
                          : null,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _VoteData {
  final int likes;
  final int dislikes;
  final String? myVote;
  final bool isVotingOpen;

  const _VoteData({
    required this.likes,
    required this.dislikes,
    required this.myVote,
    required this.isVotingOpen,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _VoteData &&
          runtimeType == other.runtimeType &&
          likes == other.likes &&
          dislikes == other.dislikes &&
          myVote == other.myVote &&
          isVotingOpen == other.isVotingOpen;

  @override
  int get hashCode => Object.hash(likes, dislikes, myVote, isVotingOpen);
}

class _VoteButton extends StatelessWidget {
  final int count;
  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final VoidCallback? onTap;

  const _VoteButton({
    required this.count,
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isActive
                ? activeColor.withValues(alpha: 0.12)
                : ColorManager.primaryDark.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isActive
                  ? activeColor.withValues(alpha: 0.8)
                  : ColorManager.paper400.withValues(alpha: 0.2),
              width: isActive ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                count > 0 ? '$count' : '٠',
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isActive ? activeColor : ColorManager.paper200,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                icon,
                size: 18.sp,
                color: isActive ? activeColor : ColorManager.paper300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

