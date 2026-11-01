import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/stories/domain/entities/story_details_entity.dart';
import 'package:hekayat_3al_raf/features/stories/domain/usecases/get_story_details_usecase.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/bloc/story_details_state.dart';

class StoryDetailsCubit extends Cubit<StoryDetailsState> {
  final GetStoryDetailsUseCase _getStoryDetailsUseCase;

  StoryDetailsCubit(this._getStoryDetailsUseCase)
      : super(const StoryDetailsState());

  Future<void> loadStoryDetails(String storyId) async {
    emit(state.copyWith(status: StoryDetailsStatus.loading));

    final result = await _getStoryDetailsUseCase(storyId);

    switch (result) {
      case ApiSuccess<StoryDetailsEntity>(:final data):
        emit(state.copyWith(
          status: StoryDetailsStatus.success,
          story: data,
        ));
      case ApiFailure<StoryDetailsEntity>(:final failure):
        emit(state.copyWith(
          status: StoryDetailsStatus.failure,
          errorMessage: failure.message,
        ));
    }
  }
}

