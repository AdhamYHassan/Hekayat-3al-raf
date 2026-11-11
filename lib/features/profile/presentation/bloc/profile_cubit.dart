import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
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
    required String name,
    required String phone,
    required String bio,
    String? avatar,
    String? avatarFilePath,
  }) async {
    final currentState = state;
    if (currentState is! ProfileLoaded) return;

    emit(currentState.copyWith(isUpdating: true));

    final params = UpdateProfileParams(
      name: name,
      phone: phone,
      bio: bio,
      avatar: avatar,
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
        emit(currentState.copyWith(
          isUpdating: false,
          updateErrorMessage: failure.message,
        ));
    }
  }
}

