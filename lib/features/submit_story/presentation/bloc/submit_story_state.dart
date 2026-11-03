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
  final bool showAuthor; // user choice: show_author = false by default
  final bool isRecording;
  final int recordingDurationSeconds;
  final bool isSubmitting;
  final bool isSubmittedSuccessfully;
  final String? successMessage;
  final String? errorMessage;

  // Guest Fields (When not logged in)
  final String guestName;
  final String guestPhone;
  final String guestPhoneRegion;

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
    this.showAuthor = false,
    this.isRecording = false,
    this.recordingDurationSeconds = 0,
    this.isSubmitting = false,
    this.isSubmittedSuccessfully = false,
    this.successMessage,
    this.errorMessage,
    this.guestName = '',
    this.guestPhone = '',
    this.guestPhoneRegion = 'EG',
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
    bool? showAuthor,
    bool? isRecording,
    int? recordingDurationSeconds,
    bool? isSubmitting,
    bool? isSubmittedSuccessfully,
    String? successMessage,
    String? errorMessage,
    bool clearError = false,
    String? guestName,
    String? guestPhone,
    String? guestPhoneRegion,
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
      showAuthor: showAuthor ?? this.showAuthor,
      isRecording: isRecording ?? this.isRecording,
      recordingDurationSeconds:
          recordingDurationSeconds ?? this.recordingDurationSeconds,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmittedSuccessfully:
          isSubmittedSuccessfully ?? this.isSubmittedSuccessfully,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      guestName: guestName ?? this.guestName,
      guestPhone: guestPhone ?? this.guestPhone,
      guestPhoneRegion: guestPhoneRegion ?? this.guestPhoneRegion,
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
        showAuthor,
        isRecording,
        recordingDurationSeconds,
        isSubmitting,
        isSubmittedSuccessfully,
        successMessage,
        errorMessage,
        guestName,
        guestPhone,
        guestPhoneRegion,
        isAutosaving,
        isDraftSaved,
        recoverableDraft,
      ];
}
