import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/profile_user_entity.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/update_profile_params.dart';
import 'package:hekayat_3al_raf/features/profile/domain/repositories/i_profile_repository.dart';

class UpdateProfileUseCase {
  final IProfileRepository _repository;

  const UpdateProfileUseCase(this._repository);

  Future<ApiResult<ProfileUserEntity>> call(UpdateProfileParams params) =>
      _repository.updateProfile(params);
}

