import 'package:equatable/equatable.dart';

enum StoryContentType { text, audio, video }

/// Entity representing a single story card displayed in feeds.
class StoryFeedItem extends Equatable {
  final String id;
  final String title;
  final String category;
  final String excerpt;
  final String authorName;
  final String coverImageUrl;
  final StoryContentType contentType;
  final int viewsCount;
  final double rating;

  const StoryFeedItem({
    required this.id,
    required this.title,
    required this.category,
    required this.excerpt,
    required this.authorName,
    required this.coverImageUrl,
    required this.contentType,
    required this.viewsCount,
    required this.rating,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        excerpt,
        authorName,
        coverImageUrl,
        contentType,
        viewsCount,
        rating,
      ];
}

/// Entity representing the curated monthly featured story with its literary pull quote.
class FeaturedStoryEntity extends Equatable {
  final StoryFeedItem story;
  final String pullQuote;

  const FeaturedStoryEntity({
    required this.story,
    required this.pullQuote,
  });

  @override
  List<Object?> get props => [story, pullQuote];
}

