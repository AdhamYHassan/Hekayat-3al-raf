import 'package:hekayat_3al_raf/core/media/audio/model/audio_playback_state.dart';
import 'package:hekayat_3al_raf/core/media/audio/model/audio_track.dart';

abstract class IAudioPlayerService {
  Stream<AudioPlaybackState> get stateStream;

  /// Plays a track with rich metadata for notification & lockscreen
  Future<void> playTrack(AudioTrack track);

  /// Backward-compatible URL playback
  Future<void> playUrl(String url);

  Future<void> resume();
  Future<void> pause();

  /// Advancing or delaying the audio to a specific position
  Future<void> seek(Duration position);

  /// Full stop and reset
  Future<void> stop();

  /// (Memory Cleanup)
  Future<void> dispose();
}
