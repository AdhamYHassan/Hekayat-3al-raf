/// Data Transfer Objects (DTOs) for Home API Response
/// Free from build_runner and code-gen; purely using Dart 3+ native features.
library;

class HomeApiResponseDto {
  final bool status;
  final int statusCode;
  final String message;
  final HomeDataDto data;

  const HomeApiResponseDto({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory HomeApiResponseDto.fromJson(Map<String, dynamic> json) {
    return HomeApiResponseDto(
      status: json['status'] as bool? ?? false,
      statusCode: json['status_code'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: HomeDataDto.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class HomeDataDto {
  final List<SlideDto> slides;
  final List<StatDto> stats;
  final List<TopStoryDto> topStories;
  final List<RegionDto> regions;
  final List<NewsDto> news;
  final List<AmbassadorDto> ambassadors;

  const HomeDataDto({
    required this.slides,
    required this.stats,
    required this.topStories,
    required this.regions,
    required this.news,
    required this.ambassadors,
  });

  factory HomeDataDto.fromJson(Map<String, dynamic> json) {
    return HomeDataDto(
      slides: (json['slides'] as List<dynamic>?)
              ?.map((e) => SlideDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      stats: (json['stats'] as List<dynamic>?)
              ?.map((e) => StatDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      topStories: (json['top_stories'] as List<dynamic>?)
              ?.map((e) => TopStoryDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      regions: (json['regions'] as List<dynamic>?)
              ?.map((e) => RegionDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      news: (json['news'] as List<dynamic>?)
              ?.map((e) => NewsDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      ambassadors: (json['ambassadors'] as List<dynamic>?)
              ?.map((e) => AmbassadorDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class SlideDto {
  final int id;
  final String subtitle;
  final String title;
  final String highlight;
  final String description;
  final List<String> meta;
  final String image;
  final String? imagePosition;
  final String ctaLabel;
  final String? ctaUrl;
  final String? secondaryLabel;
  final String? secondaryUrl;

  const SlideDto({
    required this.id,
    required this.subtitle,
    required this.title,
    required this.highlight,
    required this.description,
    required this.meta,
    required this.image,
    this.imagePosition,
    required this.ctaLabel,
    this.ctaUrl,
    this.secondaryLabel,
    this.secondaryUrl,
  });

  factory SlideDto.fromJson(Map<String, dynamic> json) {
    return SlideDto(
      id: json['id'] as int? ?? 0,
      subtitle: json['subtitle'] as String? ?? '',
      title: json['title'] as String? ?? '',
      highlight: json['highlight'] as String? ?? '',
      description: json['description'] as String? ?? '',
      meta: (json['meta'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      image: json['image'] as String? ?? '',
      imagePosition: json['image_position'] as String?,
      ctaLabel: json['cta_label'] as String? ?? 'اكتشف الحكايات',
      ctaUrl: json['cta_url'] as String?,
      secondaryLabel: json['secondary_label'] as String?,
      secondaryUrl: json['secondary_url'] as String?,
    );
  }
}

class StatDto {
  final String key;
  final int value;
  final int rounded;
  final String label;

  const StatDto({
    required this.key,
    required this.value,
    required this.rounded,
    required this.label,
  });

  factory StatDto.fromJson(Map<String, dynamic> json) {
    return StatDto(
      key: json['key'] as String? ?? '',
      value: json['value'] as int? ?? 0,
      rounded: json['rounded'] as int? ?? 0,
      label: json['label'] as String? ?? '',
    );
  }
}

class TopStoryDto {
  final String id;
  final String title;
  final String summary;
  final String submissionType;
  final String submissionTypeLabel;
  final String? storyType;
  final String coverImage;
  final String authorName;
  final String publishedAt;
  final int viewsCount;
  final int likes;
  final int dislikes;
  final bool votingOpen;
  final String? webUrl;

  const TopStoryDto({
    required this.id,
    required this.title,
    required this.summary,
    required this.submissionType,
    required this.submissionTypeLabel,
    this.storyType,
    required this.coverImage,
    required this.authorName,
    required this.publishedAt,
    required this.viewsCount,
    required this.likes,
    required this.dislikes,
    required this.votingOpen,
    this.webUrl,
  });

  factory TopStoryDto.fromJson(Map<String, dynamic> json) {
    return TopStoryDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      submissionType: json['submission_type'] as String? ?? 'text',
      submissionTypeLabel: json['submission_type_label'] as String? ?? '',
      storyType: json['story_type'] as String?,
      coverImage: json['cover_image'] as String? ?? '',
      authorName: json['author_name'] as String? ?? '',
      publishedAt: json['published_at'] as String? ?? '',
      viewsCount: json['views_count'] as int? ?? 0,
      likes: json['likes'] as int? ?? 0,
      dislikes: json['dislikes'] as int? ?? 0,
      votingOpen: json['voting_open'] as bool? ?? false,
      webUrl: json['web_url'] as String?,
    );
  }
}

class RegionDto {
  final String slug;
  final String title;
  final String places;
  final String description;
  final String image;
  final String? imagePosition;
  final String? videoUrl;

  const RegionDto({
    required this.slug,
    required this.title,
    required this.places,
    required this.description,
    required this.image,
    this.imagePosition,
    this.videoUrl,
  });

  factory RegionDto.fromJson(Map<String, dynamic> json) {
    return RegionDto(
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      places: json['places'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String? ?? '',
      imagePosition: json['image_position'] as String?,
      videoUrl: json['video_url'] as String?,
    );
  }
}

class NewsDto {
  final int id;
  final String title;
  final String description;
  final String? image;
  final String? video;
  final String created;

  const NewsDto({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    this.video,
    required this.created,
  });

  factory NewsDto.fromJson(Map<String, dynamic> json) {
    return NewsDto(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String?,
      video: json['video'] as String?,
      created: json['created'] as String? ?? '',
    );
  }
}

class AmbassadorDto {
  final String slug;
  final String name;
  final String description;
  final String mainImage;
  final int followersCount;
  final int storiesCount;

  const AmbassadorDto({
    required this.slug,
    required this.name,
    required this.description,
    required this.mainImage,
    required this.followersCount,
    required this.storiesCount,
  });

  factory AmbassadorDto.fromJson(Map<String, dynamic> json) {
    return AmbassadorDto(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      mainImage: json['main_image'] as String? ?? '',
      followersCount: json['followers_count'] as int? ?? 0,
      storiesCount: json['stories_count'] as int? ?? 0,
    );
  }
}
