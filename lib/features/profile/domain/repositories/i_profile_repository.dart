import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/my_story_entity.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/profile_user_entity.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/update_profile_params.dart';

abstract class IProfileRepository {
  Future<ApiResult<ProfileUserEntity>> getProfile();
  Future<ApiResult<ProfileUserEntity>> updateProfile(UpdateProfileParams params);
  Future<ApiResult<List<MyStoryEntity>>> getMyStories();
}

