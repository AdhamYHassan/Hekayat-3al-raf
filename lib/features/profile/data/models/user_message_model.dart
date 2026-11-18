import 'package:hekayat_3al_raf/features/profile/domain/entities/user_message_entity.dart';

/// Data Transfer Object for User Message with defensive null-safety and parsing.
class UserMessageModel extends UserMessageEntity {
  const UserMessageModel({
    required super.id,
    required super.subject,
    required super.message,
    required super.status,
    required super.statusLabel,
    super.created,
    super.reply,
    super.repliedAt,
    super.isReplied,
  });

  factory UserMessageModel.fromJson(Map<String, dynamic> json) {
    return UserMessageModel(
      id: json['id'] as int? ?? 0,
      subject: json['subject'] as String? ?? '',
      message: json['message'] as String? ?? '',
      status: json['status'] as String? ?? '',
      statusLabel: json['status_label'] as String? ?? '',
      created: json['created'] != null
          ? DateTime.tryParse(json['created'] as String)
          : null,
      reply: json['reply'] as String?,
      repliedAt: json['replied_at'] != null
          ? DateTime.tryParse(json['replied_at'] as String)
          : null,
      isReplied: json['is_replied'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'message': message,
      'status': status,
      'status_label': statusLabel,
      'created': created?.toIso8601String(),
      'reply': reply,
      'replied_at': repliedAt?.toIso8601String(),
      'is_replied': isReplied,
    };
  }
}
