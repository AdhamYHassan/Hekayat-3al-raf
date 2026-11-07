import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/my_story_entity.dart';

sealed class MyStoriesState extends Equatable {
  const MyStoriesState();

  @override
  List<Object?> get props => [];
}

class MyStoriesInitial extends MyStoriesState {
  const MyStoriesInitial();
}

class MyStoriesLoading extends MyStoriesState {
  const MyStoriesLoading();
}

class MyStoriesLoaded extends MyStoriesState {
  final List<MyStoryEntity> stories;

  const MyStoriesLoaded(this.stories);

  int get totalCount => stories.length;
  int get inReviewCount =>
      stories.where((s) => !s.isPublished && !s.statusLabel.contains('مرفوض')).length;
  int get publishedCount => stories.where((s) => s.isPublished).length;

  @override
  List<Object?> get props => [stories];
}

class MyStoriesError extends MyStoriesState {
  final String message;

  const MyStoriesError(this.message);

  @override
  List<Object?> get props => [message];
}

