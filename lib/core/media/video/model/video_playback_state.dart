import 'package:equatable/equatable.dart';

enum VideoStatus { initial, loading, playing, paused, completed, error }

/// Immutable state representing video playback pipeline
class VideoPlaybackState extends Equatable {
  final VideoStatus status;
  final Duration position;
  final Duration duration;
  final Duration bufferedPosition;
  final double aspectRatio;
  final bool isControlsVisible;
  final String? errorMessage;

  const VideoPlaybackState({
    this.status = VideoStatus.initial,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.bufferedPosition = Duration.zero,
    this.aspectRatio = 16 / 9,
    this.isControlsVisible = true,
    this.errorMessage,
  });

  /// Ratio from 0.0 to 1.0 representing timeline progress
  double get progressRatio {
    if (duration.inMilliseconds == 0) return 0.0;
    return (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  VideoPlaybackState copyWith({
    VideoStatus? status,
    Duration? position,
    Duration? duration,
    Duration? bufferedPosition,
    double? aspectRatio,
    bool? isControlsVisible,
    String? errorMessage,
  }) {
    return VideoPlaybackState(
      status: status ?? this.status,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      bufferedPosition: bufferedPosition ?? this.bufferedPosition,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      isControlsVisible: isControlsVisible ?? this.isControlsVisible,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    position,
    duration,
    bufferedPosition,
    aspectRatio,
    isControlsVisible,
    errorMessage,
  ];
}
