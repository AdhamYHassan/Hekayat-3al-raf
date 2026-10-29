import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/home/domain/usecases/get_home_data_usecase.dart';
import 'package:hekayat_3al_raf/features/home/presentation/bloc/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeDataUseCase _getHomeDataUseCase;

  HomeCubit(this._getHomeDataUseCase) : super(const HomeInitial());

  Future<void> loadHomeData() async {
    emit(const HomeLoading());
    final result = await _getHomeDataUseCase();

    switch (result) {
      case ApiSuccess(:final data):
        emit(HomeSuccess(data));
      case ApiFailure(:final failure):
        emit(HomeError(failure.message));
    }
  }
}

