import 'package:equatable/equatable.dart';

class SubmitStoryParams extends Equatable {
  final String submissionType; // text | document | audio | video
  final String title;
  final String narratorName;
  final String summary;
  final bool showAuthor;
  final String? body;
  final String? documentPath;
  final String? audioPath;
  final String? videoPath;
  final String? thumbnailPath;

  // Guest Specific Fields
  final String? guestName;
  final String? guestPhone;
  final String? guestPhoneRegion;

  const SubmitStoryParams({
    required this.submissionType,
    required this.title,
    required this.narratorName,
    required this.summary,
    this.showAuthor = false,
    this.body,
    this.documentPath,
    this.audioPath,
    this.videoPath,
    this.thumbnailPath,
    this.guestName,
    this.guestPhone,
    this.guestPhoneRegion = 'EG',
  });

  @override
  List<Object?> get props => [
        submissionType,
        title,
        narratorName,
        summary,
        showAuthor,
        body,
        documentPath,
        audioPath,
        videoPath,
        thumbnailPath,
        guestName,
        guestPhone,
        guestPhoneRegion,
      ];
}

