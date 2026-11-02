import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/story_draft_entity.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_entities.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/repositories/i_submit_story_repository.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/usecases/clear_story_draft_usecase.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/usecases/get_story_draft_usecase.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/usecases/save_story_draft_usecase.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/bloc/submit_story_state.dart';

class SubmitStoryCubit extends Cubit<SubmitStoryState> {
  final ISubmitStoryRepository _repository;
  final SaveStoryDraftUseCase _saveDraftUseCase;
  final GetStoryDraftUseCase _getDraftUseCase;
  final ClearStoryDraftUseCase _clearDraftUseCase;

  Timer? _debounceTimer;

  SubmitStoryCubit(
    this._repository,
    this._saveDraftUseCase,
    this._getDraftUseCase,
    this._clearDraftUseCase,
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

  void toggleAnonymous(bool isAnonymous) {
    emit(state.copyWith(isAnonymous: isAnonymous, isDraftSaved: false));
    _triggerDebouncedAutosave();
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
        state.authorName.trim().isEmpty) {
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
