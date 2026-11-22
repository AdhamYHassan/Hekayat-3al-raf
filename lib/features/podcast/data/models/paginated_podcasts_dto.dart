import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/podcast/domain/entities/paginated_podcasts_entity.dart';

/// DTO for Paginated Podcasts API response.
class PaginatedPodcastsResponseDto extends Equatable {
  final bool status;
  final int statusCode;
  final String message;
  final PaginatedPodcastsDataDto data;

  const PaginatedPodcastsResponseDto({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory PaginatedPodcastsResponseDto.fromJson(Map<String, dynamic> json) {
    return PaginatedPodcastsResponseDto(
      status: json['status'] as bool? ?? false,
      statusCode: json['status_code'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: PaginatedPodcastsDataDto.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  @override
  List<Object?> get props => [status, statusCode, message, data];
}

class PaginatedPodcastsDataDto extends Equatable {
  final int count;
  final String? next;
  final String? previous;
  final List<PodcastDirectoryItemDto> results;

  const PaginatedPodcastsDataDto({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedPodcastsDataDto.fromJson(Map<String, dynamic> json) {
    return PaginatedPodcastsDataDto(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map(
                (e) => PodcastDirectoryItemDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  PaginatedPodcastsEntity toDomain() {
    return PaginatedPodcastsEntity(
      count: count,
      hasMore: next != null && next!.isNotEmpty,
      episodes: results.map((r) => r.toDomain()).toList(),
    );
  }

  @override
  List<Object?> get props => [count, next, previous, results];
}

class PodcastDirectoryItemDto extends Equatable {
  final int id;
  final int number;
  final String title;
  final String shortDescription;
  final String guest;
  final int? durationMinutes;
  final String publishedOn;
  final String image;
  final String videoUrl;
  final String? embedSrc;
  final String url;

  const PodcastDirectoryItemDto({
    required this.id,
    required this.number,
    required this.title,
    required this.shortDescription,
    required this.guest,
    this.durationMinutes,
    required this.publishedOn,
    required this.image,
    required this.videoUrl,
    this.embedSrc,
    required this.url,
  });

  factory PodcastDirectoryItemDto.fromJson(Map<String, dynamic> json) {
    final videoEmbed = json['video_embed'] as Map<String, dynamic>?;
    return PodcastDirectoryItemDto(
      id: json['id'] as int? ?? 0,
      number: json['number'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      shortDescription: json['short_description'] as String? ?? '',
      guest: json['guest'] as String? ?? '',
      durationMinutes: json['duration_minutes'] as int?,
      publishedOn: json['published_on'] as String? ?? '',
      image: json['image'] as String? ?? '',
      videoUrl: json['video_url'] as String? ?? '',
      embedSrc: videoEmbed?['src'] as String?,
      url: json['url'] as String? ?? '',
    );
  }

  PodcastDirectoryItemEntity toDomain() {
    return PodcastDirectoryItemEntity(
      id: id,
      number: number,
      title: title,
      shortDescription: shortDescription,
      guest: guest,
      durationMinutes: durationMinutes,
      publishedOn: publishedOn,
      imageUrl: image,
      videoUrl: videoUrl,
      embedSrc: embedSrc,
      webUrl: url,
    );
  }

  @override
  List<Object?> get props => [
        id,
        number,
        title,
        shortDescription,
        guest,
        durationMinutes,
        publishedOn,
        image,
        videoUrl,
        embedSrc,
        url,
      ];
}
