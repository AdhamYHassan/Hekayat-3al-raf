import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/profile_user_entity.dart';
import 'package:hekayat_3al_raf/features/profile/domain/repositories/i_profile_repository.dart';

class GetProfileUseCase {
  final IProfileRepository _repository;

  const GetProfileUseCase(this._repository);

  Future<ApiResult<ProfileUserEntity>> call() => _repository.getProfile();
}

