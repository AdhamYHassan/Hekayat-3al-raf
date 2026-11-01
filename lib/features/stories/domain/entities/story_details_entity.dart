import 'package:equatable/equatable.dart';

enum StoryMediaType { text, audio, video, document }

class StoryDetailsEntity extends Equatable {
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
  final StoryMediaUrls media;

  const StoryDetailsEntity({
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

  StoryMediaType get mediaType => switch (submissionType.toLowerCase()) {
        'audio' => StoryMediaType.audio,
        'video' => StoryMediaType.video,
        'document' => StoryMediaType.document,
        _ => StoryMediaType.text,
      };

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
        body,
        media,
      ];
}

class StoryMediaUrls extends Equatable {
  final String? audio;
  final String? video;
  final String? document;

  const StoryMediaUrls({
    this.audio,
    this.video,
    this.document,
  });

  @override
  List<Object?> get props => [audio, video, document];
}

