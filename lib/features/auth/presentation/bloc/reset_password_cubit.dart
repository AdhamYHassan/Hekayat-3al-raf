import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/password_reset_confirm_request_model.dart';
import 'package:hekayat_3al_raf/features/auth/domain/usecases/confirm_password_reset_usecase.dart';
import 'package:hekayat_3al_raf/features/auth/domain/usecases/request_password_reset_usecase.dart';
import 'package:hekayat_3al_raf/features/auth/presentation/bloc/reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final RequestPasswordResetUseCase _requestPasswordResetUseCase;
  final ConfirmPasswordResetUseCase _confirmPasswordResetUseCase;

  ResetPasswordCubit(
    this._requestPasswordResetUseCase,
    this._confirmPasswordResetUseCase,
  ) : super(const ResetPasswordInitial());

  String _currentEmail = '';
  String get currentEmail => _currentEmail;

  Future<void> requestResetCode(String email) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty) return;

    _currentEmail = trimmedEmail;
    emit(const ResetPasswordRequestLoading());

    final result = await _requestPasswordResetUseCase(trimmedEmail);

    switch (result) {
      case ApiSuccess<String>(:final data):
        emit(ResetPasswordCodeSent(
          email: trimmedEmail,
          message: data,
        ));
      case ApiFailure<String>(:final failure):
        emit(ResetPasswordFailure(
          errorMessage: failure.message,
          isConfirmStep: false,
          email: trimmedEmail,
        ));
    }
  }

  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    if (_currentEmail.isEmpty) return;

    emit(ResetPasswordConfirmLoading(email: _currentEmail));

    final request = PasswordResetConfirmRequestModel(
      email: _currentEmail,
      code: code.trim(),
      newPassword: newPassword,
    );

    final result = await _confirmPasswordResetUseCase(request);

    switch (result) {
      case ApiSuccess<String>(:final data):
        emit(ResetPasswordSuccess(message: data));
      case ApiFailure<String>(:final failure):
        emit(ResetPasswordFailure(
          errorMessage: failure.message,
          isConfirmStep: true,
          email: _currentEmail,
        ));
    }
  }

  void resetToStep1() {
    emit(const ResetPasswordInitial());
  }
}

