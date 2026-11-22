import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';

enum MomentsListStatus { initial, loading, success, failure }

class MomentsListState extends Equatable {
  final MomentsListStatus status;
  final List<MomentFeedItemEntity> moments;
  final int count;
  final bool hasMore;
  final bool isLoadingMore;
  final String? errorMessage;

  const MomentsListState({
    this.status = MomentsListStatus.initial,
    this.moments = const [],
    this.count = 0,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  MomentsListState copyWith({
    MomentsListStatus? status,
    List<MomentFeedItemEntity>? moments,
    int? count,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return MomentsListState(
      status: status ?? this.status,
      moments: moments ?? this.moments,
      count: count ?? this.count,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        moments,
        count,
        hasMore,
        isLoadingMore,
        errorMessage,
      ];
}
