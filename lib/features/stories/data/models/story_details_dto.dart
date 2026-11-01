library;

import 'package:hekayat_3al_raf/features/stories/domain/entities/story_details_entity.dart';

class StoryDetailsResponseDto {
  final bool status;
  final int statusCode;
  final String message;
  final StoryDetailsDto data;

  const StoryDetailsResponseDto({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory StoryDetailsResponseDto.fromJson(Map<String, dynamic> json) {
    return StoryDetailsResponseDto(
      status: json['status'] as bool? ?? false,
      statusCode: json['status_code'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: StoryDetailsDto.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class StoryDetailsDto {
  final String id;
  final String title;
  final String summary;
  final String submissionType;
  final String submissionTypeLabel;
  final String? storyType;
  final String coverImage;
  final String authorName;
  final String publishedAt;
  final int viewsCount;
  final int likes;
  final int dislikes;
  final bool votingOpen;
  final String? myVote;
  final String? webUrl;
  final String body;
  final StoryMediaUrlsDto media;

  const StoryDetailsDto({
    required this.id,
    required this.title,
    required this.summary,
    required this.submissionType,
    required this.submissionTypeLabel,
    this.storyType,
    required this.coverImage,
    required this.authorName,
    required this.publishedAt,
    required this.viewsCount,
    required this.likes,
    required this.dislikes,
    required this.votingOpen,
    this.myVote,
    this.webUrl,
    required this.body,
    required this.media,
  });

  factory StoryDetailsDto.fromJson(Map<String, dynamic> json) {
    return StoryDetailsDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      submissionType: json['submission_type'] as String? ?? 'text',
      submissionTypeLabel: json['submission_type_label'] as String? ?? '',
      storyType: json['story_type'] as String?,
      coverImage: json['cover_image'] as String? ?? '',
      authorName: json['author_name'] as String? ?? '',
      publishedAt: json['published_at'] as String? ?? '',
      viewsCount: json['views_count'] as int? ?? 0,
      likes: json['likes'] as int? ?? 0,
      dislikes: json['dislikes'] as int? ?? 0,
      votingOpen: json['voting_open'] as bool? ?? false,
      myVote: json['my_vote'] as String?,
      webUrl: json['web_url'] as String?,
      body: json['body'] as String? ?? '',
      media: StoryMediaUrlsDto.fromJson(json['media'] as Map<String, dynamic>? ?? {}),
    );
  }

  StoryDetailsEntity toDomain() {
    return StoryDetailsEntity(
      id: id,
      title: title,
      summary: summary,
      submissionType: submissionType,
      submissionTypeLabel: submissionTypeLabel,
      storyType: storyType,
      coverImage: coverImage,
      authorName: authorName,
      publishedAt: publishedAt,
      viewsCount: viewsCount,
      likes: likes,
      dislikes: dislikes,
      votingOpen: votingOpen,
      myVote: myVote,
      webUrl: webUrl,
      body: body,
      media: media.toDomain(),
    );
  }
}

class StoryMediaUrlsDto {
  final String? audio;
  final String? video;
  final String? document;

  const StoryMediaUrlsDto({
    this.audio,
    this.video,
    this.document,
  });

  factory StoryMediaUrlsDto.fromJson(Map<String, dynamic> json) {
    return StoryMediaUrlsDto(
      audio: json['audio'] as String?,
      video: json['video'] as String?,
      document: json['document'] as String?,
    );
  }

  StoryMediaUrls toDomain() {
    return StoryMediaUrls(
      audio: audio,
      video: video,
      document: document,
    );
  }
}

