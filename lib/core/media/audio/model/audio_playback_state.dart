import 'package:equatable/equatable.dart';

enum AudioStatus { initial, loading, playing, paused, completed, error }

class AudioPlaybackState extends Equatable {
  final AudioStatus status;
  final Duration position;
  final Duration duration;
  final Duration bufferedPosition;
  final String? errorMessage;

  const AudioPlaybackState({
    this.status = AudioStatus.initial,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.bufferedPosition = Duration.zero,
    this.errorMessage,
  });

  /// Progress ratio from 0.0 to 1.0 for the bar's progress
  double get progressRatio {
    if (duration.inMilliseconds == 0) return 0.0;
    return (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  AudioPlaybackState copyWith({
    AudioStatus? status,
    Duration? position,
    Duration? duration,
    Duration? bufferedPosition,
    String? errorMessage,
  }) {
    return AudioPlaybackState(
      status: status ?? this.status,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      bufferedPosition: bufferedPosition ?? this.bufferedPosition,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    position,
    duration,
    bufferedPosition,
    errorMessage,
  ];
}
