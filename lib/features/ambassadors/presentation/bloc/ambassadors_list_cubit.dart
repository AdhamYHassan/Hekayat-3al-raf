import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/paginated_ambassadors_entity.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/usecases/get_ambassadors_list_usecase.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/bloc/ambassadors_list_state.dart';

class AmbassadorsListCubit extends Cubit<AmbassadorsListState> {
  final GetAmbassadorsListUseCase _getAmbassadorsListUseCase;
  static const int _pageSize = 10;

  AmbassadorsListCubit(this._getAmbassadorsListUseCase)
      : super(const AmbassadorsListState());

  /// Loads the initial first page (resetting offset to 0)
  Future<void> loadAmbassadors() async {
    emit(state.copyWith(
      status: AmbassadorsListStatus.loading,
      offset: 0,
      ambassadors: [],
      hasMore: true,
      errorMessage: null,
    ));

    final result = await _getAmbassadorsListUseCase(limit: _pageSize, offset: 0);

    switch (result) {
      case ApiSuccess<PaginatedAmbassadorsEntity>(:final data):
        emit(state.copyWith(
          status: AmbassadorsListStatus.success,
          ambassadors: data.ambassadors,
          hasMore: data.hasMore,
          totalCount: data.count,
          offset: data.ambassadors.length,
        ));
      case ApiFailure<PaginatedAmbassadorsEntity>(:final failure):
        emit(state.copyWith(
          status: AmbassadorsListStatus.failure,
          errorMessage: failure.message,
        ));
    }
  }

  /// Fetches subsequent pages without resetting existing list
  Future<void> loadMoreAmbassadors() async {
    if (state.isLoadingMore || !state.hasMore || state.status == AmbassadorsListStatus.loading) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final result = await _getAmbassadorsListUseCase(
      limit: _pageSize,
      offset: state.offset,
    );

    switch (result) {
      case ApiSuccess<PaginatedAmbassadorsEntity>(:final data):
        final combined = [...state.ambassadors, ...data.ambassadors];
        emit(state.copyWith(
          status: AmbassadorsListStatus.success,
          ambassadors: combined,
          hasMore: data.hasMore,
          totalCount: data.count,
          offset: state.offset + data.ambassadors.length,
          isLoadingMore: false,
        ));
      case ApiFailure<PaginatedAmbassadorsEntity>(:final failure):
        emit(state.copyWith(
          isLoadingMore: false,
          errorMessage: failure.message,
        ));
    }
  }
}
