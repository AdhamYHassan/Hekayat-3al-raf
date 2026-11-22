import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/moments/domain/usecases/get_moment_details_usecase.dart';
import 'package:hekayat_3al_raf/features/moments/presentation/bloc/moment_details_state.dart';

class MomentDetailsCubit extends Cubit<MomentDetailsState> {
  final GetMomentDetailsUseCase _getMomentDetailsUseCase;

  MomentDetailsCubit(this._getMomentDetailsUseCase)
      : super(const MomentDetailsState());

  Future<void> loadMomentDetails(int id) async {
    emit(state.copyWith(status: MomentDetailsStatus.loading));

    final result = await _getMomentDetailsUseCase(id);

    switch (result) {
      case ApiSuccess(:final data):
        emit(
          state.copyWith(
            status: MomentDetailsStatus.success,
            moment: data,
          ),
        );
      case ApiFailure(:final failure):
        emit(
          state.copyWith(
            status: MomentDetailsStatus.failure,
            errorMessage: failure.message,
          ),
        );
    }
  }
}
