import 'package:hekayat_3al_raf/features/submit_story/domain/repositories/i_submit_story_repository.dart';

class ClearStoryDraftUseCase {
  final ISubmitStoryRepository _repository;

  const ClearStoryDraftUseCase(this._repository);

  Future<void> call() {
    return _repository.clearDraft();
  }
}

