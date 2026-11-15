import 'package:equatable/equatable.dart';

/// Entity representing a media item in the ambassador's photo gallery
class AmbassadorGalleryItem extends Equatable {
  final String id;
  final String imageUrl;
  final String caption;
  final String? year;

  const AmbassadorGalleryItem({
    required this.id,
    required this.imageUrl,
    required this.caption,
    this.year,
  });

  @override
  List<Object?> get props => [id, imageUrl, caption, year];
}

/// Entity representing questions asked to the ambassador and their responses
class AmbassadorQaItem extends Equatable {
  final String id;
  final String authorName;
  final String city;
  final String timeAgo;
  final String question;
  final String? answer;
  final bool isAnswered;

  const AmbassadorQaItem({
    required this.id,
    required this.authorName,
    required this.city,
    required this.timeAgo,
    required this.question,
    this.answer,
    this.isAnswered = false,
  });

  @override
  List<Object?> get props => [
        id,
        authorName,
        city,
        timeAgo,
        question,
        answer,
        isAnswered,
      ];
}

/// Root Aggregate Entity representing the complete cultural ambassador profile.
/// Strictly maps live backend fields without mock attributes.
class AmbassadorDetailsEntity extends Equatable {
  final String id;
  final String name;
  final String shortDescription;
  final String description;
  final String coverImageUrl;
  final int followersCount;
  final int answeredCount;
  final bool isFollowing;
  final bool canManage;
  final String webUrl;
  final List<AmbassadorGalleryItem> gallery;
  final List<AmbassadorQaItem> questions;

  const AmbassadorDetailsEntity({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.coverImageUrl,
    required this.followersCount,
    required this.answeredCount,
    required this.isFollowing,
    required this.canManage,
    required this.webUrl,
    required this.gallery,
    required this.questions,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        shortDescription,
        description,
        coverImageUrl,
        followersCount,
        answeredCount,
        isFollowing,
        canManage,
        webUrl,
        gallery,
        questions,
      ];
}
