import 'package:equatable/equatable.dart';
import '../../domain/entities/ambassador_details_entity.dart';

/// DTO for a media/gallery item in the ambassador profile
class AmbassadorMediaDto extends Equatable {
  final int id;
  final String kind;
  final String image;
  final String videoUrl;
  final String caption;
  final int order;

  const AmbassadorMediaDto({
    required this.id,
    required this.kind,
    required this.image,
    required this.videoUrl,
    required this.caption,
    required this.order,
  });

  factory AmbassadorMediaDto.fromJson(Map<String, dynamic> json) {
    return AmbassadorMediaDto(
      id: json['id'] as int? ?? 0,
      kind: json['kind'] as String? ?? 'image',
      image: (json['image'] ?? json['file']) as String? ?? '',
      videoUrl: json['video_url'] as String? ?? '',
      caption: json['caption'] as String? ?? '',
      order: json['order'] as int? ?? 0,
    );
  }

  AmbassadorGalleryItem toDomain() {
    return AmbassadorGalleryItem(
      id: id.toString(),
      imageUrl: image,
      caption: caption,
    );
  }

  @override
  List<Object?> get props => [id, kind, image, videoUrl, caption, order];
}

/// DTO representing the complete ambassador profile from `/ambassadors/{slug}/`
class AmbassadorDetailsDto extends Equatable {
  final String slug;
  final String name;
  final String shortDescription;
  final String description;
  final String mainImage;
  final int followersCount;
  final int answeredCount;
  final bool isFollowing;
  final bool canManage;
  final String webUrl;
  final List<AmbassadorMediaDto> media;

  const AmbassadorDetailsDto({
    required this.slug,
    required this.name,
    required this.shortDescription,
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
            ?.map((e) => AmbassadorMediaDto.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return AmbassadorDetailsDto(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      shortDescription: json['short_description'] as String? ?? '',
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
    return AmbassadorDetailsEntity(
      id: slug,
      name: name,
      shortDescription: shortDescription,
      description: description,
      coverImageUrl: mainImage,
      followersCount: followersCount,
      answeredCount: answeredCount,
      isFollowing: isFollowing,
      canManage: canManage,
      webUrl: webUrl,
      gallery: media.map((m) => m.toDomain()).toList(),
      questions: const [],
    );
  }

  @override
  List<Object?> get props => [
        slug,
        name,
        shortDescription,
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
