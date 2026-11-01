import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_entities.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/repositories/i_submit_story_repository.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/bloc/submit_story_state.dart';

class SubmitStoryCubit extends Cubit<SubmitStoryState> {
  final ISubmitStoryRepository _repository;

  SubmitStoryCubit(this._repository) : super(const SubmitStoryState()) {
    _initData();
  }

  void _initData() {
    emit(state.copyWith(
      storyOptions: _repository.getStoryTypeOptions(),
      reviewSteps: _repository.getReviewSteps(),
    ));
  }

  void selectFormat(StorySubmissionFormat format) {
    emit(state.copyWith(selectedFormat: format));
  }

  void setStep(int step) {
    emit(state.copyWith(currentStep: step));
  }
}

