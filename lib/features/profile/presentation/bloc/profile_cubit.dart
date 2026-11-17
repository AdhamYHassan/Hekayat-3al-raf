import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/profile_user_entity.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/update_profile_params.dart';
import 'package:hekayat_3al_raf/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:hekayat_3al_raf/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/bloc/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;

  ProfileCubit(
    this._getProfileUseCase,
    this._updateProfileUseCase,
  ) : super(const ProfileInitial());

  void setInitialUser(ProfileUserEntity user) {
    emit(ProfileLoaded(user: user));
  }

  Future<void> loadProfile() async {
    emit(const ProfileLoading());
    final result = await _getProfileUseCase();
    switch (result) {
      case ApiSuccess(:final data):
        emit(ProfileLoaded(user: data));
      case ApiFailure(:final failure):
        emit(ProfileError(failure.message));
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? phoneRegion,
    String? bio,
    String? avatarFilePath,
  }) async {
    final currentState = state;
    final currentUser = currentState is ProfileLoaded ? currentState.user : null;

    if (currentState is ProfileLoaded) {
      emit(currentState.copyWith(isUpdating: true, updateSuccessMessage: null, updateErrorMessage: null));
    }

    final params = UpdateProfileParams(
      name: name,
      email: email,
      phone: phone,
      phoneRegion: phoneRegion,
      bio: bio,
      avatarFilePath: avatarFilePath,
    );

    final result = await _updateProfileUseCase(params);
    switch (result) {
      case ApiSuccess(:final data):
        emit(ProfileLoaded(
          user: data,
          isUpdating: false,
          updateSuccessMessage: 'تم تحديث الملف الشخصي بنجاح',
        ));
      case ApiFailure(:final failure):
        if (currentUser != null) {
          emit(ProfileLoaded(
            user: currentUser,
            isUpdating: false,
            updateErrorMessage: failure.message,
          ));
        } else {
          emit(ProfileError(failure.message));
        }
    }
  }
}

