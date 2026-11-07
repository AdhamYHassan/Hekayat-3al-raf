import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/auth/domain/repositories/i_auth_repository.dart';

class RequestPasswordResetUseCase {
  final IAuthRepository _repository;

  const RequestPasswordResetUseCase(this._repository);

  Future<ApiResult<String>> call(String email) {
    return _repository.requestPasswordReset(email);
  }
}
