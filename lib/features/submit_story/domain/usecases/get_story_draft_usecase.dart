import 'package:hekayat_3al_raf/features/submit_story/domain/entities/story_draft_entity.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/repositories/i_submit_story_repository.dart';

class GetStoryDraftUseCase {
  final ISubmitStoryRepository _repository;

  const GetStoryDraftUseCase(this._repository);

  Future<StoryDraftEntity?> call() {
    return _repository.getDraft();
  }
}

