import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/profile/domain/usecases/get_my_messages_usecase.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/bloc/my_messages_state.dart';

class MyMessagesCubit extends Cubit<MyMessagesState> {
  final GetMyMessagesUseCase _getMyMessagesUseCase;

  MyMessagesCubit(this._getMyMessagesUseCase) : super(const MyMessagesInitial());

  Future<void> loadMyMessages() async {
    emit(const MyMessagesLoading());
    final result = await _getMyMessagesUseCase();
    switch (result) {
      case ApiSuccess(:final data):
        emit(MyMessagesLoaded(data));
      case ApiFailure(:final failure):
        emit(MyMessagesError(failure.message));
    }
  }
}
