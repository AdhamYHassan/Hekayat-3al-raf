import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/podcast/domain/entities/paginated_podcasts_entity.dart';

enum PodcastsListStatus { initial, loading, success, failure }

class PodcastsListState extends Equatable {
  final PodcastsListStatus status;
  final List<PodcastDirectoryItemEntity> episodes;
  final int count;
  final bool hasMore;
  final bool isLoadingMore;
  final String? errorMessage;

  const PodcastsListState({
    this.status = PodcastsListStatus.initial,
    this.episodes = const [],
    this.count = 0,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  PodcastsListState copyWith({
    PodcastsListStatus? status,
    List<PodcastDirectoryItemEntity>? episodes,
    int? count,
    bool? hasMore,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return PodcastsListState(
      status: status ?? this.status,
      episodes: episodes ?? this.episodes,
      count: count ?? this.count,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        episodes,
        count,
        hasMore,
        isLoadingMore,
        errorMessage,
      ];
}
