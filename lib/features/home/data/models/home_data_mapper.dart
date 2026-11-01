import 'package:hekayat_3al_raf/features/home/data/models/home_api_response_dto.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_data_entity.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_hero_slide.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_story_entity.dart';

extension HomeDataDtoMapper on HomeDataDto {
  HomeDataEntity toDomain() {
    // 1. Map Slides
    final domainSlides = slides.map((s) {
      return HomeHeroSlide(
        id: s.id.toString(),
        title: s.title,
        subtitle: s.subtitle,
        description: s.description,
        imageUrl: s.image,
        ctaLabel: s.ctaLabel,
        secondaryCtaLabel: s.secondaryLabel != null && s.secondaryLabel!.isNotEmpty
            ? s.secondaryLabel
            : null,
      );
    }).toList();

    // 2. Map Top Stories strictly from API fields
    final domainTopStories = topStories.map((t) {
      final contentType = switch (t.submissionType.toLowerCase()) {
        'audio' => StoryContentType.audio,
        'video' => StoryContentType.video,
        'document' => StoryContentType.document,
        _ => StoryContentType.text,
      };

      return StoryFeedItem(
        id: t.id,
        title: t.title,
        category: t.submissionTypeLabel.isNotEmpty ? t.submissionTypeLabel : 'حكاية',
        excerpt: t.summary,
        authorName: t.authorName,
        coverImageUrl: t.coverImage,
        contentType: contentType,
        submissionTypeLabel: t.submissionTypeLabel,
        viewsCount: t.viewsCount,
        likes: t.likes,
        rating: null, // Strictly null: API provides views_count and likes instead of rating
      );
    }).toList();

    // 3. Featured Story (derived from first story if available, without artificial fallbacks)
    final featuredStory = domainTopStories.isNotEmpty
        ? FeaturedStoryEntity(
            story: domainTopStories.first,
            pullQuote: '«${domainTopStories.first.excerpt}»',
          )
        : null;

    // 4. Map Ambassadors
    final domainAmbassadors = ambassadors.map((a) {
      return AmbassadorFeedItem(
        id: a.slug,
        name: a.name,
        role: a.description.split('\r\n').first,
        portraitUrl: a.mainImage,
      );
    }).toList();

    // 5. Map Regions
    final domainRegions = regions.map((r) {
      return RegionArchiveItem(
        id: r.slug,
        name: r.title,
        citiesSummary: r.places,
        tagline: r.description,
        photoUrl: r.image,
      );
    }).toList();

    return HomeDataEntity(
      heroSlides: domainSlides,
      featuredStory: featuredStory,
      topStories: domainTopStories,
      ambassadors: domainAmbassadors,
      regions: domainRegions,
    );
  }
}

