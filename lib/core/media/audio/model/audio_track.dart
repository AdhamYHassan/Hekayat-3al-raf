import 'package:equatable/equatable.dart';

/// Pure domain/model representation of an audio track
/// Independent of third-party libraries (just_audio or audio_service)
class AudioTrack extends Equatable {
  final String id;
  final String url;
  final String title;
  final String narrator;
  final String category;
  final String? artworkUrl;

  const AudioTrack({
    required this.id,
    required this.url,
    required this.title,
    required this.narrator,
    this.category = 'حكايات على الرف',
    this.artworkUrl,
  });

  @override
  List<Object?> get props => [
    id,
    url,
    title,
    narrator,
    category,
    artworkUrl,
  ];
}

