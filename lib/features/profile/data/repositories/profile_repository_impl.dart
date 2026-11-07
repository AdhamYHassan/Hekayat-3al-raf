import 'package:hekayat_3al_raf/core/helpers/secure_storage_helper.dart';
import 'package:hekayat_3al_raf/core/network/network_exceptions.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/profile/data/datasources/i_profile_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/my_story_entity.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/profile_user_entity.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/update_profile_params.dart';
import 'package:hekayat_3al_raf/features/profile/domain/repositories/i_profile_repository.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileRemoteDataSource _remoteDataSource;

  const ProfileRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<ProfileUserEntity>> getProfile() async {
    try {
      final user = await _remoteDataSource.getProfile();
      await _cacheUserLocally(user);
      return ApiSuccess(user);
    } catch (error) {
      return ApiFailure(NetworkExceptions.getFailure(error));
    }
  }

  @override
  Future<ApiResult<ProfileUserEntity>> updateProfile(
    UpdateProfileParams params,
  ) async {
    try {
      final user = await _remoteDataSource.updateProfile(params);
      await _cacheUserLocally(user);
      return ApiSuccess(user);
    } catch (error) {
      return ApiFailure(NetworkExceptions.getFailure(error));
    }
  }

  @override
  Future<ApiResult<List<MyStoryEntity>>> getMyStories() async {
    try {
      final stories = await _remoteDataSource.getMyStories();
      return ApiSuccess(stories);
    } catch (error) {
      return ApiFailure(NetworkExceptions.getFailure(error));
    }
  }

  Future<void> _cacheUserLocally(ProfileUserEntity user) async {
    if (user.displayName.isNotEmpty) {
      await SecureStorageHelper.saveUserName(user.displayName);
    } else if (user.name.isNotEmpty) {
      await SecureStorageHelper.saveUserName(user.name);
    }
    if (user.email.isNotEmpty) {
      await SecureStorageHelper.saveUserEmail(user.email);
    }
    if (user.phone.isNotEmpty) {
      await SecureStorageHelper.savePhoneNumber(user.phone);
    }
  }
}

