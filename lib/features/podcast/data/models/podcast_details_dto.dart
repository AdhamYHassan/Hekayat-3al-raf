import 'package:hekayat_3al_raf/features/podcast/domain/entities/podcast_details_entity.dart';

/// Data Transfer Object for Podcast Details Response.
class PodcastDetailsResponseDto {
  final bool status;
  final int statusCode;
  final String message;
  final PodcastDetailsDto data;

  const PodcastDetailsResponseDto({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory PodcastDetailsResponseDto.fromJson(Map<String, dynamic> json) {
    return PodcastDetailsResponseDto(
      status: json['status'] as bool? ?? false,
      statusCode: json['status_code'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: PodcastDetailsDto.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class PodcastDetailsDto {
  final int id;
  final int number;
  final String title;
  final String shortDescription;
  final String description;
  final String guest;
  final int? durationMinutes;
  final String publishedOn;
  final String image;
  final String videoUrl;
  final String? embedSrc;
  final String url;
  final List<PodcastEpisodeSummaryDto> more;

  const PodcastDetailsDto({
    required this.id,
    required this.number,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.guest,
    this.durationMinutes,
    required this.publishedOn,
    required this.image,
    required this.videoUrl,
    this.embedSrc,
    required this.url,
    required this.more,
  });

  factory PodcastDetailsDto.fromJson(Map<String, dynamic> json) {
    final videoEmbed = json['video_embed'] as Map<String, dynamic>?;
    return PodcastDetailsDto(
      id: json['id'] as int? ?? 0,
      number: json['number'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      shortDescription: json['short_description'] as String? ?? '',
      description: json['description'] as String? ?? '',
      guest: json['guest'] as String? ?? '',
      durationMinutes: json['duration_minutes'] as int?,
      publishedOn: json['published_on'] as String? ?? '',
      image: json['image'] as String? ?? '',
      videoUrl: json['video_url'] as String? ?? '',
      embedSrc: videoEmbed?['src'] as String?,
      url: json['url'] as String? ?? '',
      more: (json['more'] as List<dynamic>?)
              ?.map(
                (e) => PodcastEpisodeSummaryDto.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  PodcastDetailsEntity toDomain() {
    return PodcastDetailsEntity(
      id: id,
      number: number,
      title: title,
      shortDescription: shortDescription,
      description: description.isNotEmpty ? description : shortDescription,
      guest: guest,
      durationMinutes: durationMinutes,
      publishedOn: publishedOn,
      imageUrl: image,
      videoUrl: videoUrl,
      embedSrc: embedSrc,
      webUrl: url,
      moreEpisodes: more.map((e) => e.toDomain()).toList(),
    );
  }
}

class PodcastEpisodeSummaryDto {
  final int id;
  final int number;
  final String title;
  final String guest;
  final String image;
  final String videoUrl;

  const PodcastEpisodeSummaryDto({
    required this.id,
    required this.number,
    required this.title,
    required this.guest,
    required this.image,
    required this.videoUrl,
  });

  factory PodcastEpisodeSummaryDto.fromJson(Map<String, dynamic> json) {
    return PodcastEpisodeSummaryDto(
      id: json['id'] as int? ?? 0,
      number: json['number'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      guest: json['guest'] as String? ?? '',
      image: json['image'] as String? ?? '',
      videoUrl: json['video_url'] as String? ?? '',
    );
  }

  PodcastEpisodeEntitySummary toDomain() {
    return PodcastEpisodeEntitySummary(
      id: id,
      number: number,
      title: title,
      guest: guest,
      imageUrl: image,
      videoUrl: videoUrl,
    );
  }
}
