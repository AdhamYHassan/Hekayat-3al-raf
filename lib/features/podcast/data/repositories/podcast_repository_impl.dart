import 'package:hekayat_3al_raf/core/network/network_exceptions.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/podcast/data/datasources/i_podcast_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/podcast/domain/entities/paginated_podcasts_entity.dart';
import 'package:hekayat_3al_raf/features/podcast/domain/entities/podcast_details_entity.dart';
import 'package:hekayat_3al_raf/features/podcast/domain/repositories/i_podcast_repository.dart';

class PodcastRepositoryImpl implements IPodcastRepository {
  final IPodcastRemoteDataSource _remoteDataSource;

  // In-Memory cache with 5-minute TTL
  final Map<int, (PodcastDetailsEntity, DateTime)> _cache = {};
  static const Duration _cacheTtl = Duration(minutes: 5);

  PodcastRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<PodcastDetailsEntity>> getPodcastDetails(int id) async {
    final now = DateTime.now();

    // 1. Check in-memory cache
    if (_cache.containsKey(id)) {
      final (cachedEntity, timestamp) = _cache[id]!;
      if (now.difference(timestamp) < _cacheTtl) {
        return ApiSuccess(cachedEntity);
      }
    }

    try {
      // 2. Fetch from Remote DataSource
      final responseDto = await _remoteDataSource.getPodcastDetails(id);
      final entity = responseDto.data.toDomain();

      // 3. Cache result
      _cache[id] = (entity, now);
      return ApiSuccess(entity);
    } catch (e) {
      if (_cache.containsKey(id)) {
        return ApiSuccess(_cache[id]!.$1);
      }
      return ApiFailure(NetworkExceptions.getFailure(e));
    }
  }

  @override
  Future<ApiResult<PaginatedPodcastsEntity>> getPodcastsList({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final responseDto = await _remoteDataSource.getPodcastsList(
        limit: limit,
        offset: offset,
      );
      return ApiSuccess(responseDto.data.toDomain());
    } catch (e) {
      return ApiFailure(NetworkExceptions.getFailure(e));
    }
  }
}
