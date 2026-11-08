import 'package:equatable/equatable.dart';

class StoryVoteResultEntity extends Equatable {
  final String? myVote;
  final int likes;
  final int dislikes;

  const StoryVoteResultEntity({
    this.myVote,
    required this.likes,
    required this.dislikes,
  });

  factory StoryVoteResultEntity.fromJson(Map<String, dynamic> json) {
    return StoryVoteResultEntity(
      myVote: json['my_vote'] as String?,
      likes: json['likes'] as int? ?? 0,
      dislikes: json['dislikes'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [myVote, likes, dislikes];
}

