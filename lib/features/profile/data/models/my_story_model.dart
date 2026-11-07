import 'package:hekayat_3al_raf/features/profile/domain/entities/my_story_entity.dart';

class MyStoryModel extends MyStoryEntity {
  const MyStoryModel({
    required super.id,
    required super.title,
    required super.narratorName,
    required super.summary,
    required super.submissionType,
    required super.submissionTypeLabel,
    required super.statusLabel,
    super.progress,
    super.authorMessage,
    super.isPublished,
    super.showAuthor,
    super.canEditShowAuthor,
    super.viewsCount,
    super.thumbnail,
    super.audioFile,
    super.videoFile,
    super.documentFile,
    super.webUrl,
    super.created,
  });

  factory MyStoryModel.fromJson(Map<String, dynamic> json) {
    final files = json['files'] as Map<String, dynamic>?;

    DateTime? parsedDate;
    if (json['created'] != null) {
      parsedDate = DateTime.tryParse(json['created'] as String);
    }

    return MyStoryModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      narratorName: json['narrator_name'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      submissionType: json['submission_type'] as String? ?? 'text',
      submissionTypeLabel: json['submission_type_label'] as String? ?? 'قصة مكتوبة',
      statusLabel: json['status_label'] as String? ?? 'قيد المراجعة',
      progress: json['progress'] as int? ?? 1,
      authorMessage: json['author_message'] as String? ?? '',
      isPublished: json['is_published'] as bool? ?? false,
      showAuthor: json['show_author'] as bool? ?? false,
      canEditShowAuthor: json['can_edit_show_author'] as bool? ?? false,
      viewsCount: json['views_count'] as int? ?? 0,
      thumbnail: json['thumbnail'] as String?,
      audioFile: files?['audio'] as String?,
      videoFile: files?['video'] as String?,
      documentFile: files?['document'] as String?,
      webUrl: json['web_url'] as String?,
      created: parsedDate,
    );
  }
}

