import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/home/data/models/home_api_response_dto.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';
import 'package:hekayat_3al_raf/features/moments/domain/entities/paginated_moments_entity.dart';

class PaginatedMomentsResponseDto extends Equatable {
  final bool status;
  final int statusCode;
  final String message;
  final PaginatedMomentsDataDto data;

  const PaginatedMomentsResponseDto({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory PaginatedMomentsResponseDto.fromJson(Map<String, dynamic> json) {
    return PaginatedMomentsResponseDto(
      status: json['status'] as bool? ?? false,
      statusCode: json['status_code'] as int? ?? 200,
      message: json['message'] as String? ?? '',
      data: PaginatedMomentsDataDto.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  @override
  List<Object?> get props => [status, statusCode, message, data];
}

class PaginatedMomentsDataDto extends Equatable {
  final int count;
  final String? next;
  final String? previous;
  final List<MomentDto> results;

  const PaginatedMomentsDataDto({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedMomentsDataDto.fromJson(Map<String, dynamic> json) {
    return PaginatedMomentsDataDto(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => MomentDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  PaginatedMomentsEntity toDomain() {
    return PaginatedMomentsEntity(
      count: count,
      hasMore: next != null && next!.isNotEmpty,
      moments: results.map((m) {
        final kind = m.kind.toLowerCase() == 'video'
            ? MomentKind.video
            : MomentKind.photo;
        return MomentFeedItemEntity(
          id: m.id,
          kind: kind,
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
  List<Object?> get props => [count, next, previous, results];
}
