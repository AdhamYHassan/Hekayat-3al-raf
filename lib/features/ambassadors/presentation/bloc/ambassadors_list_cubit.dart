import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_list_item_entity.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/usecases/get_ambassadors_list_usecase.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/bloc/ambassadors_list_state.dart';

class AmbassadorsListCubit extends Cubit<AmbassadorsListState> {
  final GetAmbassadorsListUseCase _getAmbassadorsListUseCase;

  AmbassadorsListCubit(this._getAmbassadorsListUseCase)
      : super(const AmbassadorsListState());

  Future<void> loadAmbassadors() async {
    emit(state.copyWith(status: AmbassadorsListStatus.loading));

    final result = await _getAmbassadorsListUseCase();

    switch (result) {
      case ApiSuccess<List<AmbassadorListItemEntity>>(:final data):
        emit(state.copyWith(
          status: AmbassadorsListStatus.success,
          ambassadors: data,
        ));
      case ApiFailure<List<AmbassadorListItemEntity>>(:final failure):
        emit(state.copyWith(
          status: AmbassadorsListStatus.failure,
          errorMessage: failure.message,
        ));
    }
  }
}

