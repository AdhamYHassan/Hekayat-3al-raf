import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/stories/domain/entities/story_details_entity.dart';

enum StoryDetailsStatus { initial, loading, success, failure }

class StoryDetailsState extends Equatable {
  final StoryDetailsStatus status;
  final StoryDetailsEntity? story;
  final String? errorMessage;

  const StoryDetailsState({
    this.status = StoryDetailsStatus.initial,
    this.story,
    this.errorMessage,
  });

  StoryDetailsState copyWith({
    StoryDetailsStatus? status,
    StoryDetailsEntity? story,
    String? errorMessage,
  }) {
    return StoryDetailsState(
      status: status ?? this.status,
      story: story ?? this.story,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, story, errorMessage];
}

