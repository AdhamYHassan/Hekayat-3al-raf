import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/my_story_entity.dart';
import 'package:hekayat_3al_raf/features/profile/domain/repositories/i_profile_repository.dart';

class GetMyStoriesUseCase {
  final IProfileRepository _repository;

  const GetMyStoriesUseCase(this._repository);

  Future<ApiResult<List<MyStoryEntity>>> call() => _repository.getMyStories();
}

