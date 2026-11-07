import 'package:equatable/equatable.dart';

class MyStoryEntity extends Equatable {
  final String id;
  final String title;
  final String narratorName;
  final String summary;
  final String submissionType; // text, audio, video, document
  final String submissionTypeLabel;
  final String statusLabel; // قيد المراجعة, منشورة, مرفوضة, etc.
  final int progress;
  final String authorMessage;
  final bool isPublished;
  final bool showAuthor;
  final bool canEditShowAuthor;
  final int viewsCount;
  final String? thumbnail;
  final String? audioFile;
  final String? videoFile;
  final String? documentFile;
  final String? webUrl;
  final DateTime? created;

  const MyStoryEntity({
    required this.id,
    required this.title,
    required this.narratorName,
    required this.summary,
    required this.submissionType,
    required this.submissionTypeLabel,
    required this.statusLabel,
    this.progress = 1,
    this.authorMessage = '',
    this.isPublished = false,
    this.showAuthor = false,
    this.canEditShowAuthor = false,
    this.viewsCount = 0,
    this.thumbnail,
    this.audioFile,
    this.videoFile,
    this.documentFile,
    this.webUrl,
    this.created,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        narratorName,
        summary,
        submissionType,
        submissionTypeLabel,
        statusLabel,
        progress,
        authorMessage,
        isPublished,
        showAuthor,
        canEditShowAuthor,
        viewsCount,
        thumbnail,
        audioFile,
        videoFile,
        documentFile,
        webUrl,
        created,
      ];
}

