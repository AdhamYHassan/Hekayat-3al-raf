import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/stories/domain/entities/story_details_entity.dart';
import 'package:hekayat_3al_raf/features/stories/domain/entities/story_vote_result_entity.dart';
import 'package:hekayat_3al_raf/features/stories/domain/usecases/get_story_details_usecase.dart';
import 'package:hekayat_3al_raf/features/stories/domain/usecases/vote_story_usecase.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/bloc/story_details_state.dart';

class StoryDetailsCubit extends Cubit<StoryDetailsState> {
  final GetStoryDetailsUseCase _getStoryDetailsUseCase;
  final VoteStoryUseCase _voteStoryUseCase;

  StoryDetailsCubit(
    this._getStoryDetailsUseCase,
    this._voteStoryUseCase,
  ) : super(const StoryDetailsState());

  Future<void> loadStoryDetails(String storyId) async {
    emit(state.copyWith(status: StoryDetailsStatus.loading));

    final result = await _getStoryDetailsUseCase(storyId);

    switch (result) {
      case ApiSuccess<StoryDetailsEntity>(:final data):
        emit(state.copyWith(
          status: StoryDetailsStatus.success,
          story: data,
        ));
      case ApiFailure<StoryDetailsEntity>(:final failure):
        emit(state.copyWith(
          status: StoryDetailsStatus.failure,
          errorMessage: failure.message,
        ));
    }
  }

  /// Performs an instant Optimistic UI update for like/dislike voting
  /// and synchronizes with the backend in the background.
  /// If the user taps the same vote value again, it removes the vote as per API spec.
  Future<void> voteStory(String voteValue) async {
    final currentStory = state.story;
    if (currentStory == null || !currentStory.votingOpen) return;

    final previousStory = currentStory;
    final currentVote = currentStory.myVote;

    // Calculate optimistic state changes
    int newLikes = currentStory.likes;
    int newDislikes = currentStory.dislikes;
    String? newVote;
    bool clearVote = false;

    if (currentVote == voteValue) {
      // Toggle off (remove vote)
      clearVote = true;
      newVote = null;
      if (voteValue == 'like') {
        newLikes = (newLikes - 1).clamp(0, 999999);
      } else if (voteValue == 'dislike') {
        newDislikes = (newDislikes - 1).clamp(0, 999999);
      }
    } else {
      // New vote or switching from like to dislike / dislike to like
      newVote = voteValue;
      if (voteValue == 'like') {
        newLikes++;
        if (currentVote == 'dislike') {
          newDislikes = (newDislikes - 1).clamp(0, 999999);
        }
      } else if (voteValue == 'dislike') {
        newDislikes++;
        if (currentVote == 'like') {
          newLikes = (newLikes - 1).clamp(0, 999999);
        }
      }
    }

    // 1. Instant Optimistic State Emission (Zero UI Latency)
    final optimisticStory = currentStory.copyWith(
      likes: newLikes,
      dislikes: newDislikes,
      myVote: newVote,
      clearMyVote: clearVote,
    );

    emit(state.copyWith(story: optimisticStory));

    // 2. Dispatch network call in background
    final result = await _voteStoryUseCase(
      storyId: currentStory.id,
      value: voteValue,
    );

    // 3. Rollback on failure or update with canonical backend response
    switch (result) {
      case ApiSuccess<StoryVoteResultEntity>(:final data):
        // Update only the vote-related fields while preserving full story content
        final updatedStory = (state.story ?? currentStory).copyWith(
          likes: data.likes,
          dislikes: data.dislikes,
          myVote: data.myVote,
          clearMyVote: data.myVote == null,
        );
        emit(state.copyWith(story: updatedStory, clearVoteError: true));
      case ApiFailure<StoryVoteResultEntity>(:final failure):
        // Rollback gracefully to previous state and emit voteErrorMessage
        emit(state.copyWith(
          story: previousStory,
          voteErrorMessage: failure.message,
        ));
    }
  }
}

