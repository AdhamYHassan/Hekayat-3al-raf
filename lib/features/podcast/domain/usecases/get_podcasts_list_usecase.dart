import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/podcast/domain/entities/paginated_podcasts_entity.dart';
import 'package:hekayat_3al_raf/features/podcast/domain/repositories/i_podcast_repository.dart';

/// Use case for retrieving paginated podcast directory list.
class GetPodcastsListUseCase {
  final IPodcastRepository _repository;

  const GetPodcastsListUseCase(this._repository);

  Future<ApiResult<PaginatedPodcastsEntity>> call({
    int limit = 10,
    int offset = 0,
  }) {
    return _repository.getPodcastsList(limit: limit, offset: offset);
  }
}
