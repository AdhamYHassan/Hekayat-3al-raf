import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/podcast/domain/usecases/get_podcasts_list_usecase.dart';
import 'package:hekayat_3al_raf/features/podcast/presentation/bloc/podcasts_list_state.dart';

class PodcastsListCubit extends Cubit<PodcastsListState> {
  final GetPodcastsListUseCase _getPodcastsListUseCase;
  static const int _pageSize = 10;
  int _currentOffset = 0;

  PodcastsListCubit(this._getPodcastsListUseCase)
      : super(const PodcastsListState());

  Future<void> loadPodcasts({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentOffset = 0;
    } else {
      emit(state.copyWith(status: PodcastsListStatus.loading));
    }

    final result = await _getPodcastsListUseCase(
      limit: _pageSize,
      offset: 0,
    );

    switch (result) {
      case ApiSuccess(:final data):
        _currentOffset = data.episodes.length;
        emit(
          state.copyWith(
            status: PodcastsListStatus.success,
            episodes: data.episodes,
            count: data.count,
            hasMore: data.hasMore,
            isLoadingMore: false,
          ),
        );
      case ApiFailure(:final failure):
        emit(
          state.copyWith(
            status: PodcastsListStatus.failure,
            errorMessage: failure.message,
            isLoadingMore: false,
          ),
        );
    }
  }

  Future<void> loadMorePodcasts() async {
    if (!state.hasMore || state.isLoadingMore || state.status == PodcastsListStatus.loading) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final result = await _getPodcastsListUseCase(
      limit: _pageSize,
      offset: _currentOffset,
    );

    switch (result) {
      case ApiSuccess(:final data):
        _currentOffset += data.episodes.length;
        emit(
          state.copyWith(
            episodes: [...state.episodes, ...data.episodes],
            hasMore: data.hasMore,
            isLoadingMore: false,
          ),
        );
      case ApiFailure(:final failure):
        emit(
          state.copyWith(
            isLoadingMore: false,
            errorMessage: failure.message,
          ),
        );
    }
  }
}
