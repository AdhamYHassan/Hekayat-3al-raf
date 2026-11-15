import 'package:equatable/equatable.dart';
import '../../domain/entities/ambassador_list_item_entity.dart';

/// DTO for an item in the ambassadors list directory
class AmbassadorListItemDto extends Equatable {
  final String slug;
  final String name;
  final String shortDescription;
  final String description;
  final String mainImage;
  final int followersCount;

  const AmbassadorListItemDto({
    required this.slug,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.mainImage,
    required this.followersCount,
  });

  factory AmbassadorListItemDto.fromJson(Map<String, dynamic> json) {
    return AmbassadorListItemDto(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      shortDescription: json['short_description'] as String? ?? '',
      description: json['description'] as String? ?? '',
      mainImage: json['main_image'] as String? ?? '',
      followersCount: json['followers_count'] as int? ?? 0,
    );
  }

  AmbassadorListItemEntity toDomain() {
    return AmbassadorListItemEntity(
      id: slug,
      name: name,
      shortDescription: shortDescription,
      description: description,
      imageUrl: mainImage,
      followersCount: followersCount,
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
      ];
}

/// DTO representing the paginated response for `/ambassadors/`
class PaginatedAmbassadorsDto extends Equatable {
  final int count;
  final String? next;
  final String? previous;
  final List<AmbassadorListItemDto> results;

  const PaginatedAmbassadorsDto({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedAmbassadorsDto.fromJson(Map<String, dynamic> json) {
    final resultsList = (json['results'] as List<dynamic>?)
            ?.map((e) => AmbassadorListItemDto.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return PaginatedAmbassadorsDto(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: resultsList,
    );
  }

  @override
  List<Object?> get props => [count, next, previous, results];
}
