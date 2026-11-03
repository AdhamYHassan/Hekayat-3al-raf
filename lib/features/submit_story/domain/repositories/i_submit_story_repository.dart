import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/story_draft_entity.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_entities.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_params.dart';

abstract class ISubmitStoryRepository {
  List<StoryTypeOptionEntity> getStoryTypeOptions();
  List<ReviewStepEntity> getReviewSteps();
  Future<void> saveDraft(StoryDraftEntity draft);
  Future<StoryDraftEntity?> getDraft();
  Future<void> clearDraft();

  /// Submits the completed story via multipart/form-data
  Future<ApiResult<Map<String, dynamic>>> submitStory(SubmitStoryParams params);
}


