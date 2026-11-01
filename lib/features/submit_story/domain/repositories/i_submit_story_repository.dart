import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_entities.dart';

abstract class ISubmitStoryRepository {
  List<StoryTypeOptionEntity> getStoryTypeOptions();
  List<ReviewStepEntity> getReviewSteps();
}

