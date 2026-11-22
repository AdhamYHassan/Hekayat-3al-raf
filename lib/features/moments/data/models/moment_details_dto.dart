import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/home/data/models/home_api_response_dto.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';
import 'package:hekayat_3al_raf/features/moments/domain/entities/moment_details_entity.dart';

class MomentDetailsResponseDto extends Equatable {
  final bool status;
  final int statusCode;
  final String message;
  final MomentDetailsDto data;

  const MomentDetailsResponseDto({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory MomentDetailsResponseDto.fromJson(Map<String, dynamic> json) {
    return MomentDetailsResponseDto(
      status: json['status'] as bool? ?? false,
      statusCode: json['status_code'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: MomentDetailsDto.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  @override
  List<Object?> get props => [status, statusCode, message, data];
}

class MomentDetailsDto extends Equatable {
  final int id;
  final String kind;
  final String title;
  final String description;
  final String? image;
  final String? video;
  final String url;
  final String created;
  final List<MomentDto> more;

  const MomentDetailsDto({
    required this.id,
    required this.kind,
    required this.title,
    required this.description,
    this.image,
    this.video,
    required this.url,
    required this.created,
    required this.more,
  });

  factory MomentDetailsDto.fromJson(Map<String, dynamic> json) {
    return MomentDetailsDto(
      id: json['id'] as int? ?? 0,
      kind: json['kind'] as String? ?? 'photo',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String?,
      video: json['video'] as String?,
      url: json['url'] as String? ?? '',
      created: json['created'] as String? ?? '',
      more: (json['more'] as List<dynamic>?)
              ?.map((e) => MomentDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  MomentDetailsEntity toDomain() {
    final momentKind = kind.toLowerCase() == 'video'
        ? MomentKind.video
        : MomentKind.photo;

    return MomentDetailsEntity(
      id: id,
      kind: momentKind,
      title: title,
      description: description,
      imageUrl: image,
      videoUrl: video,
      webUrl: url,
      created: created,
      moreMoments: more.map((m) {
        final k = m.kind.toLowerCase() == 'video'
            ? MomentKind.video
            : MomentKind.photo;
        return MomentFeedItemEntity(
          id: m.id,
          kind: k,
          title: m.title,
          description: m.description,
          imageUrl: m.image,
          videoUrl: m.video,
          webUrl: m.url,
          created: m.created,
        );
      }).toList(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        kind,
        title,
        description,
        image,
        video,
        url,
        created,
        more,
      ];
}
