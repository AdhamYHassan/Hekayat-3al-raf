import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_hero_slide.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_story_entity.dart';

/// Aggregated Root Entity for the Home Feed.
/// Combines all home screen sections in a single immutable payload.
class HomeDataEntity extends Equatable {
  final List<HomeHeroSlide> heroSlides;
  final FeaturedStoryEntity featuredStory;
  final List<StoryFeedItem> topStories;
  final List<AmbassadorFeedItem> ambassadors;
  final List<RegionArchiveItem> regions;

  const HomeDataEntity({
    required this.heroSlides,
    required this.featuredStory,
    required this.topStories,
    required this.ambassadors,
    required this.regions,
  });

  @override
  List<Object?> get props => [
        heroSlides,
        featuredStory,
        topStories,
        ambassadors,
        regions,
      ];
}

