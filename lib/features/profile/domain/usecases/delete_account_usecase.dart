import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/profile/domain/repositories/i_profile_repository.dart';

class DeleteAccountUseCase {
  final IProfileRepository _repository;

  const DeleteAccountUseCase(this._repository);

  Future<ApiResult<void>> call(String password) {
    return _repository.deleteAccount(password);
  }
}

