import 'package:hekayat_3al_raf/features/submit_story/data/models/submit_story_request_model.dart';

abstract class ISubmitStoryRemoteDataSource {
  Future<Map<String, dynamic>> submitStory(SubmitStoryRequestModel request);
}

