import 'package:hekayat_3al_raf/core/media/video/model/video_playback_state.dart';

abstract class IVideoPlayerService {
  /// Stream emitting video playback progress and status updates
  Stream<VideoPlaybackState> get stateStream;

  /// Loads and prepares a video from a remote URL (MP4 / HLS m3u8)
  Future<void> initialize(String videoUrl);
  Future<void> play();
  Future<void> pause();
  Future<void> seek(Duration position);
  Future<void> setControlsVisibility(bool isVisible);

  /// Hardware and GPU memory cleanup
  Future<void> dispose();
}
