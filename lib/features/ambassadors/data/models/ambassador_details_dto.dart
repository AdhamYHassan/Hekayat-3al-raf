import 'package:equatable/equatable.dart';
import '../../domain/entities/ambassador_details_entity.dart';

/// DTO for a media item inside an ambassador profile
class AmbassadorMediaItemDto extends Equatable {
  final int id;
  final String kind;
  final String image;
  final String videoUrl;
  final String? embed;
  final String caption;
  final int order;

  const AmbassadorMediaItemDto({
    required this.id,
    required this.kind,
    required this.image,
    required this.videoUrl,
    this.embed,
    required this.caption,
    required this.order,
  });

  factory AmbassadorMediaItemDto.fromJson(Map<String, dynamic> json) {
    return AmbassadorMediaItemDto(
      id: json['id'] as int? ?? 0,
      kind: json['kind'] as String? ?? 'image',
      image: json['image'] as String? ?? '',
      videoUrl: json['video_url'] as String? ?? '',
      embed: json['embed'] as String?,
      caption: json['caption'] as String? ?? '',
      order: json['order'] as int? ?? 0,
    );
  }

  AmbassadorGalleryItem toDomain() {
    return AmbassadorGalleryItem(
      id: id.toString(),
      imageUrl: image,
      caption: caption,
      year: null,
    );
  }

  @override
  List<Object?> get props => [id, kind, image, videoUrl, embed, caption, order];
}

/// DTO representing the response from `/ambassadors/{slug}/`
class AmbassadorDetailsDto extends Equatable {
  final String slug;
  final String name;
  final String description;
  final String mainImage;
  final int followersCount;
  final int answeredCount;
  final bool isFollowing;
  final bool canManage;
  final String webUrl;
  final List<AmbassadorMediaItemDto> media;

  const AmbassadorDetailsDto({
    required this.slug,
    required this.name,
    required this.description,
    required this.mainImage,
    required this.followersCount,
    required this.answeredCount,
    required this.isFollowing,
    required this.canManage,
    required this.webUrl,
    required this.media,
  });

  factory AmbassadorDetailsDto.fromJson(Map<String, dynamic> json) {
    final mediaList = (json['media'] as List<dynamic>?)
            ?.map((e) => AmbassadorMediaItemDto.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return AmbassadorDetailsDto(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      mainImage: json['main_image'] as String? ?? '',
      followersCount: json['followers_count'] as int? ?? 0,
      answeredCount: json['answered_count'] as int? ?? 0,
      isFollowing: json['is_following'] as bool? ?? false,
      canManage: json['can_manage'] as bool? ?? false,
      webUrl: json['web_url'] as String? ?? '',
      media: mediaList,
    );
  }

  AmbassadorDetailsEntity toDomain() {
    // Split bio into clean paragraphs
    final cleanDescription = description.replaceAll('\r\n', '\n');
    final paragraphs = cleanDescription
        .split('\n')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    return AmbassadorDetailsEntity(
      id: slug,
      name: name,
      role: paragraphs.isNotEmpty ? paragraphs.first : '',
      city: 'القاهرة، مصر',
      joinYear: '2024',
      coverImageUrl: mainImage,
      quote: paragraphs.length > 1 ? paragraphs[1] : description,
      tags: const ['صانع محتوى', 'القصة الكاملة', 'وثائقي'],
      storiesCount: media.length,
      answeredQuestionsCount: answeredCount,
      bioParagraphs: paragraphs.isNotEmpty ? paragraphs : [description],
      pullQuote: paragraphs.length > 1 ? paragraphs[1] : '',
      gallery: media.map((m) => m.toDomain()).toList(),
      selectedStories: const [],
      questions: const [],
    );
  }

  @override
  List<Object?> get props => [
        slug,
        name,
        description,
        mainImage,
        followersCount,
        answeredCount,
        isFollowing,
        canManage,
        webUrl,
        media,
      ];
}

