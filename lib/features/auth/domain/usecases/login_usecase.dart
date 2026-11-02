import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/login_request_model.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/login_response_model.dart';
import 'package:hekayat_3al_raf/features/auth/domain/repositories/i_auth_repository.dart';

class LoginUseCase {
  final IAuthRepository _repository;

  const LoginUseCase(this._repository);

  Future<ApiResult<LoginResponseModel>> call(LoginRequestModel request) {
    return _repository.login(request);
  }
}

