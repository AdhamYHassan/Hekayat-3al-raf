import 'package:equatable/equatable.dart';

class StoryDraftEntity extends Equatable {
  final String title;
  final String authorName;
  final String summary;
  final String body;
  final String format;
  final bool isAnonymous;
  final DateTime lastSavedAt;

  const StoryDraftEntity({
    required this.title,
    required this.authorName,
    required this.summary,
    required this.body,
    required this.format,
    required this.isAnonymous,
    required this.lastSavedAt,
  });

  bool get isEmpty =>
      title.trim().isEmpty &&
      authorName.trim().isEmpty &&
      summary.trim().isEmpty &&
      body.trim().isEmpty;

  bool get isNotEmpty => !isEmpty;

  @override
  List<Object?> get props => [
        title,
        authorName,
        summary,
        body,
        format,
        isAnonymous,
        lastSavedAt,
      ];
}

