import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/moments/domain/usecases/get_moments_list_usecase.dart';
import 'package:hekayat_3al_raf/features/moments/presentation/bloc/moments_list_state.dart';

class MomentsListCubit extends Cubit<MomentsListState> {
  final GetMomentsListUseCase _getMomentsListUseCase;
  static const int _pageSize = 10;
  int _currentOffset = 0;

  MomentsListCubit(this._getMomentsListUseCase)
      : super(const MomentsListState());

  Future<void> loadMoments({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentOffset = 0;
    } else {
      emit(state.copyWith(status: MomentsListStatus.loading));
    }

    final result = await _getMomentsListUseCase(
      limit: _pageSize,
      offset: 0,
    );

    switch (result) {
      case ApiSuccess(:final data):
        _currentOffset = data.moments.length;
        emit(
          state.copyWith(
            status: MomentsListStatus.success,
            moments: data.moments,
            count: data.count,
            hasMore: data.hasMore,
            isLoadingMore: false,
          ),
        );
      case ApiFailure(:final failure):
        emit(
          state.copyWith(
            status: MomentsListStatus.failure,
            errorMessage: failure.message,
            isLoadingMore: false,
          ),
        );
    }
  }

  Future<void> loadMoreMoments() async {
    if (!state.hasMore || state.isLoadingMore || state.status == MomentsListStatus.loading) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final result = await _getMomentsListUseCase(
      limit: _pageSize,
      offset: _currentOffset,
    );

    switch (result) {
      case ApiSuccess(:final data):
        _currentOffset += data.moments.length;
        emit(
          state.copyWith(
            moments: [...state.moments, ...data.moments],
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
