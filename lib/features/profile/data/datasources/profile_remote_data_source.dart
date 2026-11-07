import 'package:hekayat_3al_raf/core/network/api_endpoints.dart';
import 'package:hekayat_3al_raf/core/network/inetwork_helper.dart';
import 'package:hekayat_3al_raf/features/profile/data/datasources/i_profile_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/profile/data/models/my_story_model.dart';
import 'package:hekayat_3al_raf/features/profile/data/models/profile_user_model.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/update_profile_params.dart';

class ProfileRemoteDataSource implements IProfileRemoteDataSource {
  final InetworkHelper _networkHelper;

  const ProfileRemoteDataSource(this._networkHelper);

  @override
  Future<ProfileUserModel> getProfile() async {
    final response = await _networkHelper.get(ApiEndpoints.profile);
    final json = response.data as Map<String, dynamic>;
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return ProfileUserModel.fromJson(data);
  }

  @override
  Future<ProfileUserModel> updateProfile(UpdateProfileParams params) async {
    final response = await _networkHelper.patch(
      ApiEndpoints.profile,
      data: params.toJson(),
    );
    final json = response.data as Map<String, dynamic>;
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return ProfileUserModel.fromJson(data);
  }

  @override
  Future<List<MyStoryModel>> getMyStories() async {
    final response = await _networkHelper.get(ApiEndpoints.myStories);
    final json = response.data as Map<String, dynamic>;
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    final results = data['results'] as List<dynamic>? ?? [];
    return results
        .map((item) => MyStoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

