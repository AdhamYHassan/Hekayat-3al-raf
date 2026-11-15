import 'package:equatable/equatable.dart';

/// Entity representing an ambassador in the ambassadors list directory.
/// Contains only real fields delivered by the live API.
class AmbassadorListItemEntity extends Equatable {
  final String id;
  final String name;
  final String shortDescription;
  final String description;
  final String imageUrl;
  final int followersCount;

  const AmbassadorListItemEntity({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.imageUrl,
    required this.followersCount,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        shortDescription,
        description,
        imageUrl,
        followersCount,
      ];
}
