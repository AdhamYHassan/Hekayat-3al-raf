import 'package:equatable/equatable.dart';

/// Entity representing a podcast episode in the paginated directory.
class PodcastDirectoryItemEntity extends Equatable {
  final int id;
  final int number;
  final String title;
  final String shortDescription;
  final String guest;
  final int? durationMinutes;
  final String publishedOn;
  final String imageUrl;
  final String videoUrl;
  final String? embedSrc;
  final String webUrl;

  const PodcastDirectoryItemEntity({
    required this.id,
    required this.number,
    required this.title,
    required this.shortDescription,
    required this.guest,
    this.durationMinutes,
    required this.publishedOn,
    required this.imageUrl,
    required this.videoUrl,
    this.embedSrc,
    required this.webUrl,
  });

  @override
  List<Object?> get props => [
        id,
        number,
        title,
        shortDescription,
        guest,
        durationMinutes,
        publishedOn,
        imageUrl,
        videoUrl,
        embedSrc,
        webUrl,
      ];
}

/// Paginated result of podcast episodes with count & hasMore support.
class PaginatedPodcastsEntity extends Equatable {
  final int count;
  final bool hasMore;
  final List<PodcastDirectoryItemEntity> episodes;

  const PaginatedPodcastsEntity({
    required this.count,
    required this.hasMore,
    required this.episodes,
  });

  @override
  List<Object?> get props => [count, hasMore, episodes];
}
