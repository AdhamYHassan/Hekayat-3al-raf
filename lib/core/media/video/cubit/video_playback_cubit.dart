import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/media/audio/service/i_audio_player_service.dart';
import 'package:hekayat_3al_raf/core/media/video/model/video_playback_state.dart';
import 'package:hekayat_3al_raf/core/media/video/service/default_video_player_service.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerCubit extends Cubit<VideoPlaybackState> {
  final DefaultVideoPlayerService _videoService;
  final IAudioPlayerService? _audioService;
  StreamSubscription<VideoPlaybackState>? _subscription;
  Timer? _controlsTimer;

  VideoPlayerCubit(
    this._videoService, [
    this._audioService,
  ]) : super(const VideoPlaybackState()) {
    _subscription = _videoService.stateStream.listen(emit);
  }

  VideoPlayerController? get activeController => _videoService.activeController;

  /// Loads and prepares a video URL
  Future<void> loadVideo(String url) async {
    await _videoService.initialize(url);
    _startControlsTimer();
  }

  /// Toggle play and pause with background audio suspension
  Future<void> togglePlay() async {
    if (state.status == VideoStatus.playing) {
      await _videoService.pause();
      _cancelControlsTimer();
      _videoService.setControlsVisibility(true);
    } else {
      // Pause background audio if playing to prevent noise overlap
      await _audioService?.pause();
      await _videoService.play();
      _startControlsTimer();
    }
  }

  Future<void> seek(Duration position) async {
    await _videoService.seek(position);
  }

  /// Toggle overlay controls visibility with auto-hide timer
  void toggleControls() {
    final nextVisibility = !state.isControlsVisible;
    _videoService.setControlsVisibility(nextVisibility);
    if (nextVisibility && state.status == VideoStatus.playing) {
      _startControlsTimer();
    } else {
      _cancelControlsTimer();
    }
  }

  void _startControlsTimer() {
    _cancelControlsTimer();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (state.status == VideoStatus.playing) {
        _videoService.setControlsVisibility(false);
      }
    });
  }

  void _cancelControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = null;
  }

  @override
  Future<void> close() async {
    _cancelControlsTimer();
    await _subscription?.cancel();
    await _videoService.dispose();
    return super.close();
  }
}
