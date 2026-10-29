import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_hero_slide.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_story_entity.dart';

abstract class IHomeRemoteDataSource {
  Future<List<HomeHeroSlide>> getHeroSlides();
  Future<FeaturedStoryEntity> getFeaturedStory();
  Future<List<StoryFeedItem>> getTopStories();
  Future<List<AmbassadorFeedItem>> getAmbassadors();
  Future<List<RegionArchiveItem>> getRegions();
}

