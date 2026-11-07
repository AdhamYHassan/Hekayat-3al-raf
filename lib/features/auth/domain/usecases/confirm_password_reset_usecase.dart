import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/password_reset_confirm_request_model.dart';
import 'package:hekayat_3al_raf/features/auth/domain/repositories/i_auth_repository.dart';

class ConfirmPasswordResetUseCase {
  final IAuthRepository _repository;

  const ConfirmPasswordResetUseCase(this._repository);

  Future<ApiResult<String>> call(PasswordResetConfirmRequestModel request) {
    return _repository.confirmPasswordReset(request);
  }
}
