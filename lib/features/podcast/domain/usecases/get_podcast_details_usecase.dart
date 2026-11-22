import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/podcast/domain/entities/podcast_details_entity.dart';
import 'package:hekayat_3al_raf/features/podcast/domain/repositories/i_podcast_repository.dart';

/// Single-responsibility Use Case for fetching podcast details.
class GetPodcastDetailsUseCase {
  final IPodcastRepository _repository;

  const GetPodcastDetailsUseCase(this._repository);

  Future<ApiResult<PodcastDetailsEntity>> call(int id) {
    return _repository.getPodcastDetails(id);
  }
}
