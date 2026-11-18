import 'package:equatable/equatable.dart';

/// Pure domain representation of a user's contact/support message.
/// Independent of network parsers or serialization frameworks.
class UserMessageEntity extends Equatable {
  final int id;
  final String subject;
  final String message;
  final String status;
  final String statusLabel;
  final DateTime? created;
  final String? reply;
  final DateTime? repliedAt;
  final bool isReplied;

  const UserMessageEntity({
    required this.id,
    required this.subject,
    required this.message,
    required this.status,
    required this.statusLabel,
    this.created,
    this.reply,
    this.repliedAt,
    this.isReplied = false,
  });

  @override
  List<Object?> get props => [
        id,
        subject,
        message,
        status,
        statusLabel,
        created,
        reply,
        repliedAt,
        isReplied,
      ];
}
