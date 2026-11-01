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

/// Entity representing selected stories curated by this ambassador
class AmbassadorStoryItem extends Equatable {
  final String id;
  final String title;
  final String category;
  final String viewsCount;
  final double rating;

  const AmbassadorStoryItem({
    required this.id,
    required this.title,
    required this.category,
    required this.viewsCount,
    required this.rating,
  });

  @override
  List<Object?> get props => [id, title, category, viewsCount, rating];
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

/// Root Aggregate Entity representing the complete cultural ambassador profile
class AmbassadorDetailsEntity extends Equatable {
  final String id;
  final String name;
  final String role;
  final String city;
  final String joinYear;
  final String coverImageUrl;
  final String quote;
  final List<String> tags;
  final int storiesCount;
  final int answeredQuestionsCount;
  final List<String> bioParagraphs;
  final String pullQuote;
  final List<AmbassadorGalleryItem> gallery;
  final List<AmbassadorStoryItem> selectedStories;
  final List<AmbassadorQaItem> questions;

  const AmbassadorDetailsEntity({
    required this.id,
    required this.name,
    required this.role,
    required this.city,
    required this.joinYear,
    required this.coverImageUrl,
    required this.quote,
    required this.tags,
    required this.storiesCount,
    required this.answeredQuestionsCount,
    required this.bioParagraphs,
    required this.pullQuote,
    required this.gallery,
    required this.selectedStories,
    required this.questions,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        role,
        city,
        joinYear,
        coverImageUrl,
        quote,
        tags,
        storiesCount,
        answeredQuestionsCount,
        bioParagraphs,
        pullQuote,
        gallery,
        selectedStories,
        questions,
      ];
}

