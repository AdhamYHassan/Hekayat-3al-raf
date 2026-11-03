import 'dart:convert';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/story_draft_entity.dart';

class StoryDraftModel extends StoryDraftEntity {
  const StoryDraftModel({
    required super.title,
    required super.authorName,
    required super.summary,
    required super.body,
    required super.format,
    required super.isAnonymous,
    super.recordedAudioPath,
    super.recordingDurationSeconds = 0,
    required super.lastSavedAt,
  });

  factory StoryDraftModel.fromEntity(StoryDraftEntity entity) {
    return StoryDraftModel(
      title: entity.title,
      authorName: entity.authorName,
      summary: entity.summary,
      body: entity.body,
      format: entity.format,
      isAnonymous: entity.isAnonymous,
      recordedAudioPath: entity.recordedAudioPath,
      recordingDurationSeconds: entity.recordingDurationSeconds,
      lastSavedAt: entity.lastSavedAt,
    );
  }

  factory StoryDraftModel.fromJson(Map<String, dynamic> json) {
    return StoryDraftModel(
      title: json['title'] as String? ?? '',
      authorName: json['author_name'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      body: json['body'] as String? ?? '',
      format: json['format'] as String? ?? 'written',
      isAnonymous: json['is_anonymous'] as bool? ?? false,
      recordedAudioPath: json['recorded_audio_path'] as String?,
      recordingDurationSeconds: json['recording_duration_seconds'] as int? ?? 0,
      lastSavedAt: json['last_saved_at'] != null
          ? DateTime.tryParse(json['last_saved_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author_name': authorName,
      'summary': summary,
      'body': body,
      'format': format,
      'is_anonymous': isAnonymous,
      'recorded_audio_path': recordedAudioPath,
      'recording_duration_seconds': recordingDurationSeconds,
      'last_saved_at': lastSavedAt.toIso8601String(),
    };
  }

  String encode() => jsonEncode(toJson());

  static StoryDraftModel? decode(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return StoryDraftModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }
}
