import 'package:equatable/equatable.dart';
import '../../domain/entities/ambassador_list_item_entity.dart';

enum AmbassadorsListStatus { initial, loading, success, failure }

/// State managing paginated ambassadors directory with deep Equatable comparison
class AmbassadorsListState extends Equatable {
  final AmbassadorsListStatus status;
  final List<AmbassadorListItemEntity> ambassadors;
  final bool isLoadingMore;
  final bool hasMore;
  final int offset;
  final int totalCount;
  final String? errorMessage;

  const AmbassadorsListState({
    this.status = AmbassadorsListStatus.initial,
    this.ambassadors = const [],
    this.isLoadingMore = false,
    this.hasMore = true,
    this.offset = 0,
    this.totalCount = 0,
    this.errorMessage,
  });

  AmbassadorsListState copyWith({
    AmbassadorsListStatus? status,
    List<AmbassadorListItemEntity>? ambassadors,
    bool? isLoadingMore,
    bool? hasMore,
    int? offset,
    int? totalCount,
    String? errorMessage,
  }) {
    return AmbassadorsListState(
      status: status ?? this.status,
      ambassadors: ambassadors ?? this.ambassadors,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      totalCount: totalCount ?? this.totalCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        ambassadors,
        isLoadingMore,
        hasMore,
        offset,
        totalCount,
        errorMessage,
      ];
}
