import 'package:equatable/equatable.dart';

/// Clean domain entity representing full podcast details.
/// Zero framework dependencies, strictly immutable with Equatable.
class PodcastDetailsEntity extends Equatable {
  final int id;
  final int number;
  final String title;
  final String shortDescription;
  final String description;
  final String guest;
  final int? durationMinutes;
  final String publishedOn;
  final String imageUrl;
  final String videoUrl;
  final String? embedSrc;
  final String webUrl;
  final List<PodcastEpisodeEntitySummary> moreEpisodes;

  const PodcastDetailsEntity({
    required this.id,
    required this.number,
    required this.title,
    required this.shortDescription,
    required this.description,
    required this.guest,
    this.durationMinutes,
    required this.publishedOn,
    required this.imageUrl,
    required this.videoUrl,
    this.embedSrc,
    required this.webUrl,
    this.moreEpisodes = const [],
  });

  @override
  List<Object?> get props => [
        id,
        number,
        title,
        shortDescription,
        description,
        guest,
        durationMinutes,
        publishedOn,
        imageUrl,
        videoUrl,
        embedSrc,
        webUrl,
        moreEpisodes,
      ];
}

class PodcastEpisodeEntitySummary extends Equatable {
  final int id;
  final int number;
  final String title;
  final String guest;
  final String imageUrl;
  final String videoUrl;

  const PodcastEpisodeEntitySummary({
    required this.id,
    required this.number,
    required this.title,
    required this.guest,
    required this.imageUrl,
    required this.videoUrl,
  });

  @override
  List<Object?> get props => [id, number, title, guest, imageUrl, videoUrl];
}
