import 'package:hekayat_3al_raf/features/profile/data/models/my_story_model.dart';
import 'package:hekayat_3al_raf/features/profile/data/models/profile_user_model.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/update_profile_params.dart';

abstract class IProfileRemoteDataSource {
  Future<ProfileUserModel> getProfile();
  Future<ProfileUserModel> updateProfile(UpdateProfileParams params);
  Future<List<MyStoryModel>> getMyStories();
}

