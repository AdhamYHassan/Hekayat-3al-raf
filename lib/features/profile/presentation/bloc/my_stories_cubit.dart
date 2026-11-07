import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/profile/domain/usecases/get_my_stories_usecase.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/bloc/my_stories_state.dart';

class MyStoriesCubit extends Cubit<MyStoriesState> {
  final GetMyStoriesUseCase _getMyStoriesUseCase;

  MyStoriesCubit(this._getMyStoriesUseCase) : super(const MyStoriesInitial());

  Future<void> loadMyStories() async {
    emit(const MyStoriesLoading());
    final result = await _getMyStoriesUseCase();
    switch (result) {
      case ApiSuccess(:final data):
        emit(MyStoriesLoaded(data));
      case ApiFailure(:final failure):
        emit(MyStoriesError(failure.message));
    }
  }
}

