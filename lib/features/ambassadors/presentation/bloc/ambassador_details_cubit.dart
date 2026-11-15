import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/helpers/secure_storage_helper.dart';
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
    required String ambassadorSlug,
    required String body,
  }) async {
    if (state.details == null) return;

    // Check token locally first to save unnecessary API round-trips
    final token = await SecureStorageHelper.getAccessToken();
    if (token == null || token.trim().isEmpty) {
      emit(state.copyWith(
        isSubmittingQuestion: false,
        errorMessage: 'auth.login_required',
      ));
      return;
    }

    emit(state.copyWith(isSubmittingQuestion: true));

    final result = await _ambassadorRepository.submitQuestion(
      ambassadorSlug: ambassadorSlug,
      body: body,
    );

    switch (result) {
      case ApiSuccess<AmbassadorQaItem>(:final data):
        // Prepend newly submitted question to the state list
        final updatedList = [data, ...state.details!.questions];
        final updatedEntity = AmbassadorDetailsEntity(
          id: state.details!.id,
          name: state.details!.name,
          shortDescription: state.details!.shortDescription,
          description: state.details!.description,
          coverImageUrl: state.details!.coverImageUrl,
          followersCount: state.details!.followersCount,
          answeredCount: state.details!.answeredCount,
          isFollowing: state.details!.isFollowing,
          canManage: state.details!.canManage,
          webUrl: state.details!.webUrl,
          gallery: state.details!.gallery,
          questions: updatedList,
        );

        emit(state.copyWith(
          isSubmittingQuestion: false,
          details: updatedEntity,
          questionSubmitSuccess: 'ambassadors.question_submit_success'.tr(),
          errorMessage: null,
        ));
      case ApiFailure<AmbassadorQaItem>(:final failure):
        emit(state.copyWith(
          isSubmittingQuestion: false,
          errorMessage: failure.message,
          questionSubmitSuccess: null,
        ));
    }
  }
}

