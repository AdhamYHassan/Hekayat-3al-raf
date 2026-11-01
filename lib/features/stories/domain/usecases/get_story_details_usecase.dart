import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/stories/domain/entities/story_details_entity.dart';
import 'package:hekayat_3al_raf/features/stories/domain/repositories/i_story_repository.dart';

class GetStoryDetailsUseCase {
  final IStoryRepository _repository;

  const GetStoryDetailsUseCase(this._repository);

  Future<ApiResult<StoryDetailsEntity>> call(String storyId) {
    return _repository.getStoryDetails(storyId);
  }
}

