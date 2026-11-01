import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_entities.dart';

class SubmitStoryState extends Equatable {
  final int currentStep;
  final StorySubmissionFormat? selectedFormat;
  final List<StoryTypeOptionEntity> storyOptions;
  final List<ReviewStepEntity> reviewSteps;

  const SubmitStoryState({
    this.currentStep = 1,
    this.selectedFormat,
    this.storyOptions = const [],
    this.reviewSteps = const [],
  });

  SubmitStoryState copyWith({
    int? currentStep,
    StorySubmissionFormat? selectedFormat,
    List<StoryTypeOptionEntity>? storyOptions,
    List<ReviewStepEntity>? reviewSteps,
  }) {
    return SubmitStoryState(
      currentStep: currentStep ?? this.currentStep,
      selectedFormat: selectedFormat ?? this.selectedFormat,
      storyOptions: storyOptions ?? this.storyOptions,
      reviewSteps: reviewSteps ?? this.reviewSteps,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        selectedFormat,
        storyOptions,
        reviewSteps,
      ];
}

