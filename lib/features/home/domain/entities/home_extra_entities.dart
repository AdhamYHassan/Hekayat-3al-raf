import 'package:equatable/equatable.dart';

/// Entity representing cultural ambassadors on the home screen.
class AmbassadorFeedItem extends Equatable {
  final String id;
  final String name;
  final String role;
  final String portraitUrl;

  const AmbassadorFeedItem({
    required this.id,
    required this.name,
    required this.role,
    required this.portraitUrl,
  });

  @override
  List<Object?> get props => [id, name, role, portraitUrl];
}

/// Entity representing cultural regions (Egypt, Levant, Gulf, Sudan).
class RegionArchiveItem extends Equatable {
  final String id;
  final String name;
  final String citiesSummary;
  final String tagline;
  final String photoUrl;

  const RegionArchiveItem({
    required this.id,
    required this.name,
    required this.citiesSummary,
    required this.tagline,
    required this.photoUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        citiesSummary,
        tagline,
        photoUrl,
      ];
}

/// Entity representing podcast episode items.
class PodcastEpisodeEntity extends Equatable {
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

  const PodcastEpisodeEntity({
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

enum MomentKind { photo, video }

/// Entity representing a fleeting moment (cultural snapshot or brief story).
class MomentFeedItemEntity extends Equatable {
  final int id;
  final MomentKind kind;
  final String title;
  final String description;
  final String? imageUrl;
  final String? videoUrl;
  final String webUrl;
  final String created;

  const MomentFeedItemEntity({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    this.imageUrl,
    this.videoUrl,
    required this.webUrl,
    required this.created,
  });

  @override
  List<Object?> get props => [
        id,
        kind,
        title,
        description,
        imageUrl,
        videoUrl,
        webUrl,
        created,
      ];
}

