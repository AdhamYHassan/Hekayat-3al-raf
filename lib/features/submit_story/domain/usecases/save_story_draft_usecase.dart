import 'package:hekayat_3al_raf/features/submit_story/domain/entities/story_draft_entity.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/repositories/i_submit_story_repository.dart';

class SaveStoryDraftUseCase {
  final ISubmitStoryRepository _repository;

  const SaveStoryDraftUseCase(this._repository);

  Future<void> call(StoryDraftEntity draft) {
    return _repository.saveDraft(draft);
  }
}

