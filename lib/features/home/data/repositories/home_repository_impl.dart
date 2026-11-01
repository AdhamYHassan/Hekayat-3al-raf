import 'package:hekayat_3al_raf/core/network/failure.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/home/data/datasources/home_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/home/data/datasources/i_home_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_data_entity.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_hero_slide.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_story_entity.dart';
import 'package:hekayat_3al_raf/features/home/domain/repositories/i_home_repository.dart';

/// Concrete repository orchestrating home data with Smart In-Memory TTL Caching.
///
/// Ensures 0ms latency when navigating back from story/ambassador details,
/// protecting both user experience and server load from redundant network hits.
class HomeRepositoryImpl implements IHomeRepository {
  final IHomeRemoteDataSource _remoteDataSource;

  // 1. In-Memory Cache with 5-minute Time-To-Live (TTL)
  HomeDataEntity? _cachedHomeData;
  DateTime? _lastFetchTime;
  static const Duration _cacheTtl = Duration(minutes: 5);

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<HomeDataEntity>> getHomeData({bool forceRefresh = false}) async {
    final now = DateTime.now();

    // 2. Serve instantly from Memory Cache if valid and not a forced pull-to-refresh
    if (!forceRefresh &&
        _cachedHomeData != null &&
        _lastFetchTime != null &&
        now.difference(_lastFetchTime!) < _cacheTtl) {
      return ApiSuccess(_cachedHomeData!);
    }

    try {
      HomeDataEntity homeData;

      // 3. Optimized path if remote data source supports direct single-shot fetch
      if (_remoteDataSource is HomeRemoteDataSource) {
        homeData = await (_remoteDataSource).getCompleteHomeData();
      } else {
        // Fallback concurrent orchestration
        final results = await Future.wait([
          _remoteDataSource.getHeroSlides(),
          _remoteDataSource.getFeaturedStory(),
          _remoteDataSource.getTopStories(),
          _remoteDataSource.getAmbassadors(),
          _remoteDataSource.getRegions(),
        ]);

        homeData = HomeDataEntity(
          heroSlides: results[0] as List<HomeHeroSlide>,
          featuredStory: results[1] as FeaturedStoryEntity?,
          topStories: results[2] as List<StoryFeedItem>,
          ambassadors: results[3] as List<AmbassadorFeedItem>,
          regions: results[4] as List<RegionArchiveItem>,
        );
      }

      // 4. Update memory cache with fresh data
      _cachedHomeData = homeData;
      _lastFetchTime = now;

      return ApiSuccess(homeData);
    } catch (e) {
      // 5. Resilience fallback: return stale cache if network fails
      if (_cachedHomeData != null) {
        return ApiSuccess(_cachedHomeData!);
      }
      return ApiFailure(ServerFailure(e.toString()));
    }
  }
}
