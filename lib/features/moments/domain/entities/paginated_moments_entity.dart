import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';

/// Paginated result of moments directory.
class PaginatedMomentsEntity extends Equatable {
  final int count;
  final bool hasMore;
  final List<MomentFeedItemEntity> moments;

  const PaginatedMomentsEntity({
    required this.count,
    required this.hasMore,
    required this.moments,
  });

  @override
  List<Object?> get props => [count, hasMore, moments];
}
