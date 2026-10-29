import 'package:hekayat_3al_raf/core/network/failure.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/home/data/datasources/i_home_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_data_entity.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_hero_slide.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_story_entity.dart';
import 'package:hekayat_3al_raf/features/home/domain/repositories/i_home_repository.dart';

/// Concrete repository orchestrating home data sources.
///
/// Clean Architecture contract implementation.
class HomeRepositoryImpl implements IHomeRepository {
  final IHomeRemoteDataSource _remoteDataSource;

  const HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<HomeDataEntity>> getHomeData() async {
    try {
      // =======================================================================
      // NOTE ON MULTI-API ORCHESTRATION (Future.wait):
      // -----------------------------------------------------------------------
      // In case the backend provides home data across multiple discrete APIs:
      // (e.g. /hero-slides, /featured, /top-stories, /ambassadors, /regions)
      // we execute all calls CONCURRENTLY via Future.wait below.
      // This reduces total latency from (T1 + T2 + T3 + T4 + T5) down to
      // MAX(T1..T5), ensuring a blistering fast 60FPS UI launch.
      // =======================================================================
      final results = await Future.wait([
        _remoteDataSource.getHeroSlides(),
        _remoteDataSource.getFeaturedStory(),
        _remoteDataSource.getTopStories(),
        _remoteDataSource.getAmbassadors(),
        _remoteDataSource.getRegions(),
      ]);

      final homeData = HomeDataEntity(
        heroSlides: results[0] as List<HomeHeroSlide>,
        featuredStory: results[1] as FeaturedStoryEntity,
        topStories: results[2] as List<StoryFeedItem>,
        ambassadors: results[3] as List<AmbassadorFeedItem>,
        regions: results[4] as List<RegionArchiveItem>,
      );

      return ApiSuccess(homeData);
    } catch (e) {
      return ApiFailure(
        ServerFailure(e.toString()),
      );
    }
  }
}
