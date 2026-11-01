import 'package:equatable/equatable.dart';
import '../../domain/entities/story_type_entity.dart';
import '../../presentation/widgets/story_card_item.dart';

/// Entity representing a story in the stories list feed
class StoryListItemEntity extends Equatable {
  final String id;
  final String title;
  final String summary;
  final String submissionType;
  final String submissionTypeLabel;
  final StoryCardMediaType mediaType;
  final StoryTypeEntity? storyType;
  final String coverImage;
  final String authorName;
  final String publishedAt;
  final int viewsCount;
  final int likes;
  final int dislikes;
  final bool votingOpen;
  final String? myVote;
  final String webUrl;

  const StoryListItemEntity({
    required this.id,
    required this.title,
    required this.summary,
    required this.submissionType,
    required this.submissionTypeLabel,
    required this.mediaType,
    this.storyType,
    required this.coverImage,
    required this.authorName,
    required this.publishedAt,
    required this.viewsCount,
    required this.likes,
    required this.dislikes,
    required this.votingOpen,
    this.myVote,
    required this.webUrl,
  });

  String get viewsFormatted {
    if (viewsCount >= 1000) {
      final formatted = (viewsCount / 1000).toStringAsFixed(1);
      return '$formatted ألف';
    }
    return '$viewsCount';
  }

  @override
  List<Object?> get props => [
        id,
        title,
        summary,
        submissionType,
        submissionTypeLabel,
        mediaType,
        storyType,
        coverImage,
        authorName,
        publishedAt,
        viewsCount,
        likes,
        dislikes,
        votingOpen,
        myVote,
        webUrl,
      ];
}

/// Paginated result of stories list
class PaginatedStoriesEntity extends Equatable {
  final int count;
  final bool hasMore;
  final List<StoryListItemEntity> stories;

  const PaginatedStoriesEntity({
    required this.count,
    required this.hasMore,
    required this.stories,
  });

  @override
  List<Object?> get props => [count, hasMore, stories];
}

/// DTO for a story item inside `/stories/`
class StoryListItemDto extends Equatable {
  final String id;
  final String title;
  final String summary;
  final String submissionType;
  final String submissionTypeLabel;
  final StoryTypeDto? storyType;
  final String? coverImage;
  final String authorName;
  final String publishedAt;
  final int viewsCount;
  final int likes;
  final int dislikes;
  final bool votingOpen;
  final String? myVote;
  final String webUrl;

  const StoryListItemDto({
    required this.id,
    required this.title,
    required this.summary,
    required this.submissionType,
    required this.submissionTypeLabel,
    this.storyType,
    this.coverImage,
    required this.authorName,
    required this.publishedAt,
    required this.viewsCount,
    required this.likes,
    required this.dislikes,
    required this.votingOpen,
    this.myVote,
    required this.webUrl,
  });

  factory StoryListItemDto.fromJson(Map<String, dynamic> json) {
    StoryTypeDto? parsedType;
    if (json['story_type'] is Map<String, dynamic>) {
      parsedType = StoryTypeDto.fromJson(json['story_type'] as Map<String, dynamic>);
    }

    return StoryListItemDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      submissionType: json['submission_type'] as String? ?? 'text',
      submissionTypeLabel: json['submission_type_label'] as String? ?? 'قصة مكتوبة',
      storyType: parsedType,
      coverImage: json['cover_image'] as String?,
      authorName: json['author_name'] as String? ?? '',
      publishedAt: json['published_at'] as String? ?? '',
      viewsCount: json['views_count'] as int? ?? 0,
      likes: json['likes'] as int? ?? 0,
      dislikes: json['dislikes'] as int? ?? 0,
      votingOpen: json['voting_open'] as bool? ?? false,
      myVote: json['my_vote'] as String?,
      webUrl: json['web_url'] as String? ?? '',
    );
  }

  StoryListItemEntity toDomain() {
    final media = switch (submissionType) {
      'audio' => StoryCardMediaType.audio,
      'video' => StoryCardMediaType.video,
      'document' => StoryCardMediaType.document,
      _ => StoryCardMediaType.text,
    };

    return StoryListItemEntity(
      id: id,
      title: title,
      summary: summary,
      submissionType: submissionType,
      submissionTypeLabel: submissionTypeLabel,
      mediaType: media,
      storyType: storyType?.toDomain(),
      coverImage: coverImage ?? '',
      authorName: authorName,
      publishedAt: publishedAt,
      viewsCount: viewsCount,
      likes: likes,
      dislikes: dislikes,
      votingOpen: votingOpen,
      myVote: myVote,
      webUrl: webUrl,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        summary,
        submissionType,
        submissionTypeLabel,
        storyType,
        coverImage,
        authorName,
        publishedAt,
        viewsCount,
        likes,
        dislikes,
        votingOpen,
        myVote,
        webUrl,
      ];
}

/// DTO for paginated `/stories/` API response
class PaginatedStoriesDto extends Equatable {
  final int count;
  final String? next;
  final String? previous;
  final List<StoryListItemDto> results;

  const PaginatedStoriesDto({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedStoriesDto.fromJson(Map<String, dynamic> json) {
    final list = (json['results'] as List<dynamic>?)
            ?.map((e) => StoryListItemDto.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return PaginatedStoriesDto(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: list,
    );
  }

  @override
  List<Object?> get props => [count, next, previous, results];
}
