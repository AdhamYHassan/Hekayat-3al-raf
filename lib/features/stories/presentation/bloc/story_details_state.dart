import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/stories/domain/entities/story_details_entity.dart';

enum StoryDetailsStatus { initial, loading, success, failure }

class StoryDetailsState extends Equatable {
  final StoryDetailsStatus status;
  final StoryDetailsEntity? story;
  final String? errorMessage;
  final String? voteErrorMessage;

  const StoryDetailsState({
    this.status = StoryDetailsStatus.initial,
    this.story,
    this.errorMessage,
    this.voteErrorMessage,
  });

  StoryDetailsState copyWith({
    StoryDetailsStatus? status,
    StoryDetailsEntity? story,
    String? errorMessage,
    String? voteErrorMessage,
    bool clearVoteError = false,
  }) {
    return StoryDetailsState(
      status: status ?? this.status,
      story: story ?? this.story,
      errorMessage: errorMessage ?? this.errorMessage,
      voteErrorMessage: clearVoteError ? null : (voteErrorMessage ?? this.voteErrorMessage),
    );
  }

  @override
  List<Object?> get props => [status, story, errorMessage, voteErrorMessage];
}

