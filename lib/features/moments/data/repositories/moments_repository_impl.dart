import 'package:hekayat_3al_raf/core/network/network_exceptions.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/moments/data/datasources/i_moments_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/moments/domain/entities/moment_details_entity.dart';
import 'package:hekayat_3al_raf/features/moments/domain/entities/paginated_moments_entity.dart';
import 'package:hekayat_3al_raf/features/moments/domain/repositories/i_moments_repository.dart';

class MomentsRepositoryImpl implements IMomentsRepository {
  final IMomentsRemoteDataSource _remoteDataSource;

  // In-Memory cache with 5-minute TTL
  final Map<int, (MomentDetailsEntity, DateTime)> _detailsCache = {};
  (PaginatedMomentsEntity, DateTime)? _listInitialPageCache;
  static const Duration _cacheTtl = Duration(minutes: 5);

  MomentsRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<MomentDetailsEntity>> getMomentDetails(int id) async {
    final now = DateTime.now();

    if (_detailsCache.containsKey(id)) {
      final (cachedEntity, timestamp) = _detailsCache[id]!;
      if (now.difference(timestamp) < _cacheTtl) {
        return ApiSuccess(cachedEntity);
      }
    }

    try {
      final responseDto = await _remoteDataSource.getMomentDetails(id);
      final entity = responseDto.data.toDomain();
      _detailsCache[id] = (entity, now);
      return ApiSuccess(entity);
    } catch (e) {
      if (_detailsCache.containsKey(id)) {
        return ApiSuccess(_detailsCache[id]!.$1);
      }
      return ApiFailure(NetworkExceptions.getFailure(e));
    }
  }

  @override
  Future<ApiResult<PaginatedMomentsEntity>> getMomentsList({
    int limit = 10,
    int offset = 0,
  }) async {
    final now = DateTime.now();

    // Cache initial page (offset == 0) to provide instant load and offline resilience
    if (offset == 0 && _listInitialPageCache != null) {
      final (cachedEntity, timestamp) = _listInitialPageCache!;
      if (now.difference(timestamp) < _cacheTtl) {
        return ApiSuccess(cachedEntity);
      }
    }

    try {
      final responseDto = await _remoteDataSource.getMomentsList(
        limit: limit,
        offset: offset,
      );
      final entity = responseDto.data.toDomain();
      if (offset == 0) {
        _listInitialPageCache = (entity, now);
      }
      return ApiSuccess(entity);
    } catch (e) {
      if (offset == 0 && _listInitialPageCache != null) {
        return ApiSuccess(_listInitialPageCache!.$1);
      }
      return ApiFailure(NetworkExceptions.getFailure(e));
    }
  }
}
