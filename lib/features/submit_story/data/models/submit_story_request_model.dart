import 'package:dio/dio.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_params.dart';

class SubmitStoryRequestModel {
  final SubmitStoryParams params;

  const SubmitStoryRequestModel(this.params);

  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {
      'submission_type': params.submissionType,
      'title': params.title,
      'narrator_name': params.narratorName,
      'summary': params.summary,
      'show_author': params.showAuthor,
    };

    // Body content for text stories
    if (params.submissionType == 'text' && params.body != null) {
      map['body'] = params.body;
    }

    // Document file
    if (params.submissionType == 'document' && params.documentPath != null) {
      map['document'] = await MultipartFile.fromFile(
        params.documentPath!,
        filename: params.documentPath!.split('/').last,
      );
    }

    // Audio file
    if (params.submissionType == 'audio' && params.audioPath != null) {
      map['audio'] = await MultipartFile.fromFile(
        params.audioPath!,
        filename: params.audioPath!.split('/').last,
      );
    }

    // Video file
    if (params.submissionType == 'video' && params.videoPath != null) {
      map['video'] = await MultipartFile.fromFile(
        params.videoPath!,
        filename: params.videoPath!.split('/').last,
      );
    }

    // Thumbnail / Cover image
    if (params.thumbnailPath != null && params.thumbnailPath!.isNotEmpty) {
      map['thumbnail'] = await MultipartFile.fromFile(
        params.thumbnailPath!,
        filename: params.thumbnailPath!.split('/').last,
      );
    }

    // Guest fields
    if (params.guestName != null && params.guestName!.isNotEmpty) {
      map['guest_name'] = params.guestName;
    }
    if (params.guestPhone != null && params.guestPhone!.isNotEmpty) {
      map['guest_phone'] = params.guestPhone;
    }
    if (params.guestPhoneRegion != null && params.guestPhoneRegion!.isNotEmpty) {
      map['guest_phone_region'] = params.guestPhoneRegion;
    }

    return FormData.fromMap(map);
  }
}

