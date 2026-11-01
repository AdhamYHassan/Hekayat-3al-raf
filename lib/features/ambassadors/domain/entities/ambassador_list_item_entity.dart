import 'package:equatable/equatable.dart';

/// Entity representing an ambassador in the ambassadors list directory
class AmbassadorListItemEntity extends Equatable {
  final String id;
  final String name;
  final String role;
  final String quote;
  final int storiesCount;
  final int answeredQuestionsCount;
  final String city;
  final String imageUrl;

  const AmbassadorListItemEntity({
    required this.id,
    required this.name,
    required this.role,
    required this.quote,
    required this.storiesCount,
    required this.answeredQuestionsCount,
    required this.city,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        role,
        quote,
        storiesCount,
        answeredQuestionsCount,
        city,
        imageUrl,
      ];
}

