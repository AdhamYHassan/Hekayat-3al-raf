import 'package:hekayat_3al_raf/features/submit_story/data/models/story_draft_model.dart';

abstract class ISubmitStoryLocalDataSource {
  Future<void> saveDraft(StoryDraftModel draft);
  Future<StoryDraftModel?> getDraft();
  Future<void> clearDraft();
}

