import 'package:hekayat_3al_raf/core/network/api_endpoints.dart';
import 'package:hekayat_3al_raf/core/network/inetwork_helper.dart';
import 'package:hekayat_3al_raf/features/home/data/datasources/i_home_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/home/data/models/home_api_response_dto.dart';
import 'package:hekayat_3al_raf/features/home/data/models/home_data_mapper.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_data_entity.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_hero_slide.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_story_entity.dart';

class HomeRemoteDataSource implements IHomeRemoteDataSource {
  final InetworkHelper _networkHelper;

  const HomeRemoteDataSource(this._networkHelper);

  /// Fetches complete aggregated home payload and parses in-place on main isolate
  /// (Fastest for ~9KB payloads, avoiding isolate spawning and heap-copy overhead).
  Future<HomeDataEntity> getCompleteHomeData() async {
    final response = await _networkHelper.get(ApiEndpoints.home);
    final rawData = response.data as Map<String, dynamic>;

    final parsedDto = HomeApiResponseDto.fromJson(rawData);
    return parsedDto.data.toDomain();
  }

  @override
  Future<List<HomeHeroSlide>> getHeroSlides() async {
    final homeData = await getCompleteHomeData();
    return homeData.heroSlides;
  }

  @override
  Future<FeaturedStoryEntity?> getFeaturedStory() async {
    final homeData = await getCompleteHomeData();
    return homeData.featuredStory;
  }

  @override
  Future<List<StoryFeedItem>> getTopStories() async {
    final homeData = await getCompleteHomeData();
    return homeData.topStories;
  }

  @override
  Future<List<AmbassadorFeedItem>> getAmbassadors() async {
    final homeData = await getCompleteHomeData();
    return homeData.ambassadors;
  }

  @override
  Future<List<RegionArchiveItem>> getRegions() async {
    final homeData = await getCompleteHomeData();
    return homeData.regions;
  }
}

