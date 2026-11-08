import 'dart:collection';
import 'package:hekayat_3al_raf/core/network/failure.dart';
import 'package:hekayat_3al_raf/core/network/network_exceptions.dart';
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

      // Fetch questions concurrently for the ambassador
      List<AmbassadorQaItem> questions = const [];
      try {
        questions = await _remoteDataSource.getAmbassadorQuestions(ambassadorId);
      } catch (_) {
        // Fallback to empty questions if endpoint fails
      }

      final completeEntity = AmbassadorDetailsEntity(
        id: details.id,
        name: details.name,
        role: details.role,
        city: details.city,
        joinYear: details.joinYear,
        coverImageUrl: details.coverImageUrl,
        quote: details.quote,
        tags: details.tags,
        storiesCount: details.storiesCount,
        answeredQuestionsCount: details.answeredQuestionsCount,
        bioParagraphs: details.bioParagraphs,
        pullQuote: details.pullQuote,
        gallery: details.gallery,
        selectedStories: details.selectedStories,
        questions: questions,
      );

      // Evict oldest if capacity exceeded
      if (_cache.length >= _maxCacheSize) {
        final oldestKey = _cache.keys.first;
        _cache.remove(oldestKey);
      }

      _cache[ambassadorId] = _CachedAmbassadorDetails(
        entity: completeEntity,
        cachedAt: DateTime.now(),
      );

      return ApiSuccess(completeEntity);
    } catch (e) {
      return ApiFailure(ServerFailure('فشل في جلب بيانات السفير: $e'));
    }
  }

  @override
  Future<ApiResult<AmbassadorQaItem>> submitQuestion({
    required String ambassadorSlug,
    required String body,
  }) async {
    try {
      final item = await _remoteDataSource.submitQuestion(
        ambassadorSlug: ambassadorSlug,
        body: body,
      );

      // Invalidate or update cache
      if (_cache.containsKey(ambassadorSlug)) {
        final cached = _cache[ambassadorSlug]!.entity;
        final updatedQuestions = [item, ...cached.questions];
        final updatedEntity = AmbassadorDetailsEntity(
          id: cached.id,
          name: cached.name,
          role: cached.role,
          city: cached.city,
          joinYear: cached.joinYear,
          coverImageUrl: cached.coverImageUrl,
          quote: cached.quote,
          tags: cached.tags,
          storiesCount: cached.storiesCount,
          answeredQuestionsCount: cached.answeredQuestionsCount,
          bioParagraphs: cached.bioParagraphs,
          pullQuote: cached.pullQuote,
          gallery: cached.gallery,
          selectedStories: cached.selectedStories,
          questions: updatedQuestions,
        );
        _cache[ambassadorSlug] = _CachedAmbassadorDetails(
          entity: updatedEntity,
          cachedAt: DateTime.now(),
        );
      }

      return ApiSuccess(item);
    } catch (e) {
      return ApiFailure(NetworkExceptions.getFailure(e));
    }
  }

  @override
  Future<ApiResult<List<AmbassadorQaItem>>> getAmbassadorQuestions(
      String ambassadorSlug) async {
    try {
      final questions =
          await _remoteDataSource.getAmbassadorQuestions(ambassadorSlug);
      return ApiSuccess(questions);
    } catch (e) {
      return ApiFailure(ServerFailure('فشل في جلب أسئلة السفير: $e'));
    }
  }
}
