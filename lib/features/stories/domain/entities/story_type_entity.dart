import 'package:equatable/equatable.dart';

/// Entity representing a story kind/category from `/stories/types/`
class StoryTypeEntity extends Equatable {
  final String slug;
  final String name;

  const StoryTypeEntity({
    required this.slug,
    required this.name,
  });

  @override
  List<Object?> get props => [slug, name];
}

/// DTO mapping `/stories/types/`
class StoryTypeDto extends Equatable {
  final String slug;
  final String name;

  const StoryTypeDto({
    required this.slug,
    required this.name,
  });

  factory StoryTypeDto.fromJson(Map<String, dynamic> json) {
    return StoryTypeDto(
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  StoryTypeEntity toDomain() => StoryTypeEntity(slug: slug, name: name);

  @override
  List<Object?> get props => [slug, name];
}

