import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/stories/domain/entities/story_type_entity.dart';
import 'package:hekayat_3al_raf/features/stories/domain/repositories/i_story_repository.dart';

class GetStoryTypesUseCase {
  final IStoryRepository _repository;

  const GetStoryTypesUseCase(this._repository);

  Future<ApiResult<List<StoryTypeEntity>>> call() {
    return _repository.getStoryTypes();
  }
}

