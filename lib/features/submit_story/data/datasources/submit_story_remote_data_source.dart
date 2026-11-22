import 'package:dio/dio.dart';
import 'package:hekayat_3al_raf/core/network/api_endpoints.dart';
import 'package:hekayat_3al_raf/core/network/inetwork_helper.dart';
import 'package:hekayat_3al_raf/features/submit_story/data/datasources/i_submit_story_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/submit_story/data/models/submit_story_request_model.dart';

class SubmitStoryRemoteDataSource implements ISubmitStoryRemoteDataSource {
  final InetworkHelper _networkHelper;

  const SubmitStoryRemoteDataSource(this._networkHelper);

  @override
  Future<Map<String, dynamic>> submitStory(
    SubmitStoryRequestModel request, {
    ProgressCallback? onSendProgress,
  }) async {
    final formData = await request.toFormData();

    final response = await _networkHelper.post(
      ApiEndpoints.submitStory,
      data: formData,
      options: Options(
        sendTimeout: const Duration(minutes: 30),
        receiveTimeout: const Duration(minutes: 5),
        headers: const {
          'Content-Type': 'multipart/form-data',
          'Accept': 'application/json',
        },
      ),
      onSendProgress: onSendProgress,
    );

    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    }
    return {'status': true, 'message': 'Success'};
  }
}

