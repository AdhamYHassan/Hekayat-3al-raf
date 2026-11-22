import 'package:hekayat_3al_raf/core/network/network_exceptions.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/moments/data/datasources/i_moments_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/moments/domain/entities/moment_details_entity.dart';
import 'package:hekayat_3al_raf/features/moments/domain/entities/paginated_moments_entity.dart';
import 'package:hekayat_3al_raf/features/moments/domain/repositories/i_moments_repository.dart';

class MomentsRepositoryImpl implements IMomentsRepository {
  final IMomentsRemoteDataSource _remoteDataSource;

  // In-Memory cache with 5-minute TTL
  final Map<int, (MomentDetailsEntity, DateTime)> _cache = {};
  static const Duration _cacheTtl = Duration(minutes: 5);

  MomentsRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<MomentDetailsEntity>> getMomentDetails(int id) async {
    final now = DateTime.now();

    if (_cache.containsKey(id)) {
      final (cachedEntity, timestamp) = _cache[id]!;
      if (now.difference(timestamp) < _cacheTtl) {
        return ApiSuccess(cachedEntity);
      }
    }

    try {
      final responseDto = await _remoteDataSource.getMomentDetails(id);
      final entity = responseDto.data.toDomain();
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
  Future<ApiResult<PaginatedMomentsEntity>> getMomentsList({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final responseDto = await _remoteDataSource.getMomentsList(
        limit: limit,
        offset: offset,
      );
      return ApiSuccess(responseDto.data.toDomain());
    } catch (e) {
      return ApiFailure(NetworkExceptions.getFailure(e));
    }
  }
}
