import 'dart:collection';
import 'package:hekayat_3al_raf/core/network/failure.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/ambassadors/data/datasources/i_ambassador_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_details_entity.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/paginated_ambassadors_entity.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/repositories/i_ambassador_repository.dart';

class _CachedAmbassadorDetails {
  final AmbassadorDetailsEntity entity;
  final DateTime cachedAt;

  const _CachedAmbassadorDetails({
    required this.entity,
    required this.cachedAt,
  });

  bool get isExpired =>
      DateTime.now().difference(cachedAt) > const Duration(minutes: 5);
}

/// Concrete Repository implementation with bounded LRU + TTL In-Memory Caching.
///
/// Features:
/// - Maximum 20 entries in memory (Strict LRU eviction prevents OOM crashes).
/// - 5-minute TTL freshness window.
/// - 0ms tab / screen re-entry.
class AmbassadorRepositoryImpl implements IAmbassadorRepository {
  final IAmbassadorRemoteDataSource _remoteDataSource;

  // LinkedHashMap maintains insertion/access order for LRU eviction
  final LinkedHashMap<String, _CachedAmbassadorDetails> _cache = LinkedHashMap();
  static const int _maxCacheSize = 20;

  AmbassadorRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<PaginatedAmbassadorsEntity>> getAmbassadorsList({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final paginated = await _remoteDataSource.getAmbassadorsList(
        limit: limit,
        offset: offset,
      );
      return ApiSuccess(paginated);
    } catch (e) {
      return ApiFailure(ServerFailure('فشل في جلب قائمة السفراء: $e'));
    }
  }

  @override
  Future<ApiResult<AmbassadorDetailsEntity>> getAmbassadorDetails(String ambassadorId) async {
    // 1. Check LRU Cache
    if (_cache.containsKey(ambassadorId)) {
      final cached = _cache[ambassadorId]!;
      if (!cached.isExpired) {
        // Refresh position in LinkedHashMap to mark as recently used
        _cache.remove(ambassadorId);
        _cache[ambassadorId] = cached;
        return ApiSuccess(cached.entity);
      } else {
        _cache.remove(ambassadorId);
      }
    }

    // 2. Fetch fresh from Remote
    try {
      final details = await _remoteDataSource.getAmbassadorDetails(ambassadorId);

      // Evict oldest if capacity exceeded
      if (_cache.length >= _maxCacheSize) {
        final oldestKey = _cache.keys.first;
        _cache.remove(oldestKey);
      }

      _cache[ambassadorId] = _CachedAmbassadorDetails(
        entity: details,
        cachedAt: DateTime.now(),
      );

      return ApiSuccess(details);
    } catch (e) {
      return ApiFailure(ServerFailure('فشل في جلب بيانات السفير: $e'));
    }
  }

  @override
  Future<ApiResult<AmbassadorQaItem>> submitQuestion({
    required String ambassadorId,
    required String authorName,
    required String city,
    required String question,
  }) async {
    try {
      final item = await _remoteDataSource.submitQuestion(
        ambassadorId: ambassadorId,
        authorName: authorName,
        city: city,
        question: question,
      );
      return ApiSuccess(item);
    } catch (e) {
      return ApiFailure(ServerFailure('فشل في إرسال السؤال: $e'));
    }
  }
}
