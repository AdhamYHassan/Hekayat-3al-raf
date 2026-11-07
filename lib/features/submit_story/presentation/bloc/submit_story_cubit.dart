import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/helpers/secure_storage_helper.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/story_draft_entity.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_entities.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_params.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/repositories/i_submit_story_repository.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/usecases/clear_story_draft_usecase.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/usecases/get_story_draft_usecase.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/usecases/save_story_draft_usecase.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/usecases/submit_story_usecase.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/bloc/submit_story_state.dart';

class SubmitStoryCubit extends Cubit<SubmitStoryState> {
  final ISubmitStoryRepository _repository;
  final SaveStoryDraftUseCase _saveDraftUseCase;
  final GetStoryDraftUseCase _getDraftUseCase;
  final ClearStoryDraftUseCase _clearDraftUseCase;
  final SubmitStoryUseCase _submitStoryUseCase;

  Timer? _debounceTimer;

  SubmitStoryCubit(
    this._repository,
    this._saveDraftUseCase,
    this._getDraftUseCase,
    this._clearDraftUseCase,
    this._submitStoryUseCase,
  ) : super(const SubmitStoryState()) {
    _initData();
  }

  Future<void> _initData() async {
    final storyOptions = _repository.getStoryTypeOptions();
    final reviewSteps = _repository.getReviewSteps();

    // Check for existing draft
    final draft = await _getDraftUseCase();

    emit(state.copyWith(
      storyOptions: storyOptions,
      reviewSteps: reviewSteps,
      recoverableDraft: draft,
    ));
  }

  void restoreDraft() {
    final draft = state.recoverableDraft;
    if (draft == null) return;

    StorySubmissionFormat format = StorySubmissionFormat.written;
    for (final opt in state.storyOptions) {
      if (opt.format.name == draft.format) {
        format = opt.format;
        break;
      }
    }

    emit(state.copyWith(
      title: draft.title,
      authorName: draft.authorName,
      summary: draft.summary,
      body: draft.body,
      isAnonymous: draft.isAnonymous,
      recordedAudioPath: draft.recordedAudioPath,
      recordingDurationSeconds: draft.recordingDurationSeconds,
      selectedFormat: format,
      currentStep: 2,
      clearRecoverableDraft: true,
      isDraftSaved: true,
    ));
  }

  Future<void> discardDraft() async {
    await _clearDraftUseCase();
    emit(state.copyWith(clearRecoverableDraft: true));
  }

  void selectFormat(StorySubmissionFormat format) {
    emit(state.copyWith(selectedFormat: format));
  }

  void resetForm() {
    emit(SubmitStoryState(
      storyOptions: state.storyOptions,
      reviewSteps: state.reviewSteps,
      currentStep: 1,
      selectedFormat: null,
      title: '',
      authorName: '',
      summary: '',
      body: '',
      coverImagePath: null,
      attachedFilePath: null,
      recordedAudioPath: null,
      isAnonymous: false,
      showAuthor: false,
      isRecording: false,
      recordingDurationSeconds: 0,
      isSubmitting: false,
      isSubmittedSuccessfully: false,
      successMessage: null,
      errorMessage: null,
      guestName: '',
      guestPhone: '',
      guestPhoneRegion: 'EG',
      isAutosaving: false,
      isDraftSaved: false,
      recoverableDraft: null,
    ));
  }

  void setStep(int step) {
    emit(state.copyWith(currentStep: step));
  }

  void updateTitle(String title) {
    emit(state.copyWith(title: title, isDraftSaved: false));
    _triggerDebouncedAutosave();
  }

  void updateAuthorName(String authorName) {
    emit(state.copyWith(authorName: authorName, isDraftSaved: false));
    _triggerDebouncedAutosave();
  }

  void updateSummary(String summary) {
    emit(state.copyWith(summary: summary, isDraftSaved: false));
    _triggerDebouncedAutosave();
  }

  void updateBody(String body) {
    emit(state.copyWith(body: body, isDraftSaved: false));
    _triggerDebouncedAutosave();
  }

  void toggleShowAuthor(bool showAuthor) {
    emit(state.copyWith(
      showAuthor: showAuthor,
      isAnonymous: !showAuthor,
      isDraftSaved: false,
    ));
    _triggerDebouncedAutosave();
  }

  void setCoverImagePath(String? path) {
    emit(state.copyWith(
      coverImagePath: path,
      clearCoverImage: path == null,
      isDraftSaved: false,
    ));
    _triggerDebouncedAutosave();
  }

  void setAttachedFilePath(String? path) {
    emit(state.copyWith(
      attachedFilePath: path,
      clearAttachedFile: path == null,
      isDraftSaved: false,
    ));
    _triggerDebouncedAutosave();
  }

  void updateGuestInfo({
    String? name,
    String? phone,
    String? region,
  }) {
    emit(state.copyWith(
      guestName: name ?? state.guestName,
      guestPhone: phone ?? state.guestPhone,
      guestPhoneRegion: region ?? state.guestPhoneRegion,
    ));
  }

  Future<bool> submitStory() async {
    final token = await SecureStorageHelper.getToken();
    final isGuest = token == null || token.isEmpty;

    // Map submission format to API slug
    final String submissionType = switch (state.selectedFormat) {
      StorySubmissionFormat.written => 'text',
      StorySubmissionFormat.document => 'document',
      StorySubmissionFormat.audio => 'audio',
      StorySubmissionFormat.video => 'video',
      null => 'text',
    };

    final params = SubmitStoryParams(
      submissionType: submissionType,
      title: state.title.trim(),
      narratorName: state.authorName.trim(),
      summary: state.summary.trim(),
      showAuthor: state.showAuthor,
      body: submissionType == 'text' ? state.body.trim() : null,
      documentPath: submissionType == 'document' ? state.attachedFilePath : null,
      videoPath: submissionType == 'video' ? state.attachedFilePath : null,
      audioPath: submissionType == 'audio' ? state.recordedAudioPath : null,
      thumbnailPath: state.coverImagePath,
      guestName: isGuest ? state.guestName.trim() : null,
      guestPhone: isGuest ? state.guestPhone.trim() : null,
      guestPhoneRegion: isGuest ? state.guestPhoneRegion : null,
    );

    emit(state.copyWith(isSubmitting: true, clearError: true));

    final result = await _submitStoryUseCase(params);

    switch (result) {
      case ApiSuccess(:final data):
        final message = data['message'] as String? ?? 'تم إرسال حكايتك بنجاح!';
        await clearDraftOnSubmitted();
        emit(state.copyWith(
          isSubmitting: false,
          isSubmittedSuccessfully: true,
          successMessage: message,
        ));
        return true;

      case ApiFailure(:final failure):
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
        ));
        return false;
    }
  }

  void setRecordedAudio({
    required String path,
    required int durationSeconds,
  }) {
    emit(state.copyWith(
      recordedAudioPath: path,
      recordingDurationSeconds: durationSeconds,
      isRecording: false,
    ));
    _saveCurrentDraft();
  }

  void clearRecordedAudio() {
    emit(state.copyWith(
      clearRecordedAudio: true,
      recordingDurationSeconds: 0,
      isRecording: false,
    ));
    _saveCurrentDraft();
  }

  void _triggerDebouncedAutosave() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1200), () {
      _saveCurrentDraft();
    });
  }

  Future<void> _saveCurrentDraft() async {
    if (state.title.trim().isEmpty &&
        state.summary.trim().isEmpty &&
        state.body.trim().isEmpty &&
        state.authorName.trim().isEmpty &&
        (state.recordedAudioPath == null || state.recordedAudioPath!.isEmpty)) {
      return;
    }

    emit(state.copyWith(isAutosaving: true));

    final draft = StoryDraftEntity(
      title: state.title,
      authorName: state.authorName,
      summary: state.summary,
      body: state.body,
      format: state.selectedFormat?.name ?? 'written',
      isAnonymous: state.isAnonymous,
      recordedAudioPath: state.recordedAudioPath,
      recordingDurationSeconds: state.recordingDurationSeconds,
      lastSavedAt: DateTime.now(),
    );

    await _saveDraftUseCase(draft);

    if (!isClosed) {
      emit(state.copyWith(
        isAutosaving: false,
        isDraftSaved: true,
      ));
    }
  }

  Future<void> clearDraftOnSubmitted() async {
    await _clearDraftUseCase();
    emit(state.copyWith(isDraftSaved: false));
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
