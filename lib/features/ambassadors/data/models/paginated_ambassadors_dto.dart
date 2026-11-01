import 'package:equatable/equatable.dart';
import '../../domain/entities/ambassador_list_item_entity.dart';

/// DTO for an item in the ambassadors list directory
class AmbassadorListItemDto extends Equatable {
  final String slug;
  final String name;
  final String description;
  final String mainImage;
  final int followersCount;

  const AmbassadorListItemDto({
    required this.slug,
    required this.name,
    required this.description,
    required this.mainImage,
    required this.followersCount,
  });

  factory AmbassadorListItemDto.fromJson(Map<String, dynamic> json) {
    return AmbassadorListItemDto(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      mainImage: json['main_image'] as String? ?? '',
      followersCount: json['followers_count'] as int? ?? 0,
    );
  }

  AmbassadorListItemEntity toDomain() {
    // Parse role from first line of description if available
    final cleanDescription = description.replaceAll('\r\n', '\n');
    final lines = cleanDescription
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    final role = lines.isNotEmpty ? lines.first : '';
    final quote = lines.length > 1 ? lines[1] : description;

    return AmbassadorListItemEntity(
      id: slug,
      name: name,
      role: role,
      quote: quote,
      storiesCount: 0,
      answeredQuestionsCount: 0,
      city: 'القاهرة، مصر',
      imageUrl: mainImage,
    );
  }

  @override
  List<Object?> get props => [slug, name, description, mainImage, followersCount];
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

