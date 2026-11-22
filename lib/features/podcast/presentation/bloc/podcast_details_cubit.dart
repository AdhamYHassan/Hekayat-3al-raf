import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/podcast/domain/usecases/get_podcast_details_usecase.dart';
import 'package:hekayat_3al_raf/features/podcast/presentation/bloc/podcast_details_state.dart';

class PodcastDetailsCubit extends Cubit<PodcastDetailsState> {
  final GetPodcastDetailsUseCase _getPodcastDetailsUseCase;

  PodcastDetailsCubit(this._getPodcastDetailsUseCase)
      : super(const PodcastDetailsState());

  Future<void> loadPodcastDetails(int id) async {
    emit(state.copyWith(status: PodcastDetailsStatus.loading));

    final result = await _getPodcastDetailsUseCase(id);

    switch (result) {
      case ApiSuccess(:final data):
        emit(
          state.copyWith(
            status: PodcastDetailsStatus.success,
            podcast: data,
          ),
        );
      case ApiFailure(:final failure):
        emit(
          state.copyWith(
            status: PodcastDetailsStatus.failure,
            errorMessage: failure.message,
          ),
        );
    }
  }
}
