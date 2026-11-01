import 'package:hekayat_3al_raf/core/network/failure.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/stories/data/datasources/i_story_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/stories/data/models/paginated_stories_dto.dart';
import 'package:hekayat_3al_raf/features/stories/domain/entities/story_details_entity.dart';
import 'package:hekayat_3al_raf/features/stories/domain/entities/story_type_entity.dart';
import 'package:hekayat_3al_raf/features/stories/domain/repositories/i_story_repository.dart';

class StoryRepositoryImpl implements IStoryRepository {
  final IStoryRemoteDataSource _remoteDataSource;

  // In-Memory Story Details Cache with 5-minute TTL
  final Map<String, (StoryDetailsEntity, DateTime)> _storyCache = {};
  static const Duration _cacheTtl = Duration(minutes: 5);

  StoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<StoryDetailsEntity>> getStoryDetails(String storyId) async {
    final now = DateTime.now();

    // 1. Check in-memory cache
    if (_storyCache.containsKey(storyId)) {
      final (cachedEntity, timestamp) = _storyCache[storyId]!;
      if (now.difference(timestamp) < _cacheTtl) {
        return ApiSuccess(cachedEntity);
      }
    }

    try {
      // 2. Fetch from Remote DataSource
      final entity = await _remoteDataSource.getStoryDetails(storyId);

      // 3. Save to cache
      _storyCache[storyId] = (entity, now);
      return ApiSuccess(entity);
    } catch (e) {
      // 4. Return cached version as fallback if network fails
      if (_storyCache.containsKey(storyId)) {
        return ApiSuccess(_storyCache[storyId]!.$1);
      }
      return ApiFailure(ServerFailure('فشل في جلب تفاصيل الحكاية: $e'));
    }
  }

  @override
  Future<ApiResult<PaginatedStoriesEntity>> getStories({
    int limit = 10,
    int offset = 0,
    String? q,
    String? sort,
    String? kind,
    String? type,
  }) async {
    try {
      final paginated = await _remoteDataSource.getStories(
        limit: limit,
        offset: offset,
        q: q,
        sort: sort,
        kind: kind,
        type: type,
      );
      return ApiSuccess(paginated);
    } catch (e) {
      return ApiFailure(ServerFailure('فشل في جلب الحكايات: $e'));
    }
  }

  @override
  Future<ApiResult<List<StoryTypeEntity>>> getStoryTypes() async {
    try {
      final types = await _remoteDataSource.getStoryTypes();
      return ApiSuccess(types);
    } catch (e) {
      return ApiFailure(ServerFailure('فشل في جلب أقسام الحكايات: $e'));
    }
  }
}

