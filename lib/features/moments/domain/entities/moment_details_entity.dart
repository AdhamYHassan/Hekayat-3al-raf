import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';

/// Entity representing complete details of a single moment.
class MomentDetailsEntity extends Equatable {
  final int id;
  final MomentKind kind;
  final String title;
  final String description;
  final String? imageUrl;
  final String? videoUrl;
  final String webUrl;
  final String created;
  final List<MomentFeedItemEntity> moreMoments;

  const MomentDetailsEntity({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    this.imageUrl,
    this.videoUrl,
    required this.webUrl,
    required this.created,
    this.moreMoments = const [],
  });

  @override
  List<Object?> get props => [
        id,
        kind,
        title,
        description,
        imageUrl,
        videoUrl,
        webUrl,
        created,
        moreMoments,
      ];
}
