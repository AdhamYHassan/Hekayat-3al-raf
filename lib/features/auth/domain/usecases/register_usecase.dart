import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/register_request_model.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/register_response_model.dart';
import 'package:hekayat_3al_raf/features/auth/domain/repositories/i_auth_repository.dart';

class RegisterUseCase {
  final IAuthRepository _repository;

  const RegisterUseCase(this._repository);

  Future<ApiResult<RegisterResponseModel>> call(RegisterRequestModel request) {
    return _repository.register(request);
  }
}

