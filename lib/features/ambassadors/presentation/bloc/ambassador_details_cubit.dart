import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_details_entity.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/repositories/i_ambassador_repository.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/usecases/get_ambassador_details_usecase.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/bloc/ambassador_details_state.dart';

class AmbassadorDetailsCubit extends Cubit<AmbassadorDetailsState> {
  final GetAmbassadorDetailsUseCase _getAmbassadorDetailsUseCase;
  final IAmbassadorRepository _ambassadorRepository;

  AmbassadorDetailsCubit(
    this._getAmbassadorDetailsUseCase,
    this._ambassadorRepository,
  ) : super(const AmbassadorDetailsState());

  Future<void> loadAmbassadorDetails(String ambassadorId) async {
    emit(state.copyWith(status: AmbassadorStatus.loading));

    final result = await _getAmbassadorDetailsUseCase(ambassadorId);

    switch (result) {
      case ApiSuccess<AmbassadorDetailsEntity>(:final data):
        emit(state.copyWith(
          status: AmbassadorStatus.success,
          details: data,
        ));
      case ApiFailure<AmbassadorDetailsEntity>(:final failure):
        emit(state.copyWith(
          status: AmbassadorStatus.failure,
          errorMessage: failure.message,
        ));
    }
  }

  Future<void> submitQuestion({
    required String ambassadorId,
    required String authorName,
    required String city,
    required String question,
  }) async {
    if (state.details == null) return;
    emit(state.copyWith(isSubmittingQuestion: true));

    final result = await _ambassadorRepository.submitQuestion(
      ambassadorId: ambassadorId,
      authorName: authorName,
      city: city,
      question: question,
    );

    switch (result) {
      case ApiSuccess<AmbassadorQaItem>(:final data):
        // Prepend newly submitted question to the state list
        final updatedList = [data, ...state.details!.questions];
        final updatedEntity = AmbassadorDetailsEntity(
          id: state.details!.id,
          name: state.details!.name,
          role: state.details!.role,
          city: state.details!.city,
          joinYear: state.details!.joinYear,
          coverImageUrl: state.details!.coverImageUrl,
          quote: state.details!.quote,
          tags: state.details!.tags,
          storiesCount: state.details!.storiesCount,
          answeredQuestionsCount: state.details!.answeredQuestionsCount,
          bioParagraphs: state.details!.bioParagraphs,
          pullQuote: state.details!.pullQuote,
          gallery: state.details!.gallery,
          selectedStories: state.details!.selectedStories,
          questions: updatedList,
        );

        emit(state.copyWith(
          isSubmittingQuestion: false,
          details: updatedEntity,
          questionSubmitSuccess: 'تم إرسال سؤالك بنجاح!',
        ));
      case ApiFailure<AmbassadorQaItem>(:final failure):
        emit(state.copyWith(
          isSubmittingQuestion: false,
          errorMessage: failure.message,
        ));
    }
  }
}

