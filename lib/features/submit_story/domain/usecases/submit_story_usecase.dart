import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_params.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/repositories/i_submit_story_repository.dart';

class SubmitStoryUseCase {
  final ISubmitStoryRepository _repository;

  const SubmitStoryUseCase(this._repository);

  Future<ApiResult<Map<String, dynamic>>> call(SubmitStoryParams params) {
    return _repository.submitStory(params);
  }
}

