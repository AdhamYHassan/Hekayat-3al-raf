import 'package:equatable/equatable.dart';
import '../../domain/entities/ambassador_details_entity.dart';

class AmbassadorQuestionDto extends Equatable {
  final int id;
  final String body;
  final String askerName;
  final String created;
  final String answer;
  final String? answeredAt;
  final bool isAnswered;

  const AmbassadorQuestionDto({
    required this.id,
    required this.body,
    required this.askerName,
    required this.created,
    required this.answer,
    this.answeredAt,
    required this.isAnswered,
  });

  factory AmbassadorQuestionDto.fromJson(Map<String, dynamic> json) {
    return AmbassadorQuestionDto(
      id: json['id'] as int? ?? 0,
      body: json['body'] as String? ?? '',
      askerName: json['asker_name'] as String? ?? '',
      created: json['created'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      answeredAt: json['answered_at'] as String?,
      isAnswered: json['is_answered'] as bool? ?? false,
    );
  }

  AmbassadorQaItem toDomain() {
    return AmbassadorQaItem(
      id: id.toString(),
      authorName: askerName.isNotEmpty ? askerName : 'مستخدم',
      city: '',
      timeAgo: _formatDate(created),
      question: body,
      answer: answer.isNotEmpty ? answer : null,
      isAnswered: isAnswered,
    );
  }

  static String _formatDate(String isoString) {
    if (isoString.isEmpty) return '';
    try {
      final date = DateTime.parse(isoString);
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inDays > 30) {
        return '${date.year}/${date.month}/${date.day}';
      } else if (diff.inDays > 0) {
        return 'منذ ${diff.inDays} يوم';
      } else if (diff.inHours > 0) {
        return 'منذ ${diff.inHours} ساعة';
      } else if (diff.inMinutes > 0) {
        return 'منذ ${diff.inMinutes} دقيقة';
      } else {
        return 'الآن';
      }
    } catch (_) {
      return '';
    }
  }

  @override
  List<Object?> get props => [id, body, askerName, created, answer, answeredAt, isAnswered];
}

