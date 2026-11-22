import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/podcast/domain/entities/paginated_podcasts_entity.dart';
import 'package:hekayat_3al_raf/features/podcast/domain/entities/podcast_details_entity.dart';

/// Contract boundary for podcast data operations.
/// Follows Interface Segregation and Dependency Inversion (DIP).
abstract interface class IPodcastRepository {
  Future<ApiResult<PodcastDetailsEntity>> getPodcastDetails(int id);
  Future<ApiResult<PaginatedPodcastsEntity>> getPodcastsList({
    int limit = 10,
    int offset = 0,
  });
}
