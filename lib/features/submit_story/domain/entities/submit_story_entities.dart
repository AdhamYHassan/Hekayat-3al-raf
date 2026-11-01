import 'package:equatable/equatable.dart';

enum StorySubmissionFormat {
  written,
  audio,
  video,
  document,
}

class StoryTypeOptionEntity extends Equatable {
  final StorySubmissionFormat format;
  final String title;
  final String description;
  final List<String> badges;

  const StoryTypeOptionEntity({
    required this.format,
    required this.title,
    required this.description,
    required this.badges,
  });

  @override
  List<Object?> get props => [format, title, description, badges];
}

class ReviewStepEntity extends Equatable {
  final String title;
  final String description;

  const ReviewStepEntity({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description];
}

