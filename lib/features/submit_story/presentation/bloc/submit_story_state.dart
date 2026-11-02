import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/story_draft_entity.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_entities.dart';

class SubmitStoryState extends Equatable {
  final int currentStep;
  final StorySubmissionFormat? selectedFormat;
  final List<StoryTypeOptionEntity> storyOptions;
  final List<ReviewStepEntity> reviewSteps;

  // Form Fields
  final String title;
  final String authorName;
  final String summary;
  final String body;
  final String? coverImagePath;
  final String? attachedFilePath;
  final String? recordedAudioPath;
  final bool isAnonymous;
  final bool isRecording;
  final int recordingDurationSeconds;
  final bool isSubmitting;
  final String? errorMessage;

  // Autosave & Recovery State
  final bool isAutosaving;
  final bool isDraftSaved;
  final StoryDraftEntity? recoverableDraft;

  const SubmitStoryState({
    this.currentStep = 1,
    this.selectedFormat,
    this.storyOptions = const [],
    this.reviewSteps = const [],
    this.title = '',
    this.authorName = '',
    this.summary = '',
    this.body = '',
    this.coverImagePath,
    this.attachedFilePath,
    this.recordedAudioPath,
    this.isAnonymous = false,
    this.isRecording = false,
    this.recordingDurationSeconds = 0,
    this.isSubmitting = false,
    this.errorMessage,
    this.isAutosaving = false,
    this.isDraftSaved = false,
    this.recoverableDraft,
  });

  bool get hasRecoverableDraft =>
      recoverableDraft != null && recoverableDraft!.isNotEmpty;

  SubmitStoryState copyWith({
    int? currentStep,
    StorySubmissionFormat? selectedFormat,
    List<StoryTypeOptionEntity>? storyOptions,
    List<ReviewStepEntity>? reviewSteps,
    String? title,
    String? authorName,
    String? summary,
    String? body,
    String? coverImagePath,
    bool clearCoverImage = false,
    String? attachedFilePath,
    bool clearAttachedFile = false,
    String? recordedAudioPath,
    bool clearRecordedAudio = false,
    bool? isAnonymous,
    bool? isRecording,
    int? recordingDurationSeconds,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    bool? isAutosaving,
    bool? isDraftSaved,
    StoryDraftEntity? recoverableDraft,
    bool clearRecoverableDraft = false,
  }) {
    return SubmitStoryState(
      currentStep: currentStep ?? this.currentStep,
      selectedFormat: selectedFormat ?? this.selectedFormat,
      storyOptions: storyOptions ?? this.storyOptions,
      reviewSteps: reviewSteps ?? this.reviewSteps,
      title: title ?? this.title,
      authorName: authorName ?? this.authorName,
      summary: summary ?? this.summary,
      body: body ?? this.body,
      coverImagePath:
          clearCoverImage ? null : (coverImagePath ?? this.coverImagePath),
      attachedFilePath:
          clearAttachedFile ? null : (attachedFilePath ?? this.attachedFilePath),
      recordedAudioPath:
          clearRecordedAudio ? null : (recordedAudioPath ?? this.recordedAudioPath),
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isRecording: isRecording ?? this.isRecording,
      recordingDurationSeconds:
          recordingDurationSeconds ?? this.recordingDurationSeconds,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isAutosaving: isAutosaving ?? this.isAutosaving,
      isDraftSaved: isDraftSaved ?? this.isDraftSaved,
      recoverableDraft: clearRecoverableDraft
          ? null
          : (recoverableDraft ?? this.recoverableDraft),
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        selectedFormat,
        storyOptions,
        reviewSteps,
        title,
        authorName,
        summary,
        body,
        coverImagePath,
        attachedFilePath,
        recordedAudioPath,
        isAnonymous,
        isRecording,
        recordingDurationSeconds,
        isSubmitting,
        errorMessage,
        isAutosaving,
        isDraftSaved,
        recoverableDraft,
      ];
}
