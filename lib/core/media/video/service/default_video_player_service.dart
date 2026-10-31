import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:hekayat_3al_raf/core/media/video/model/video_playback_state.dart';
import 'package:hekayat_3al_raf/core/media/video/service/i_video_player_service.dart';
import 'package:video_player/video_player.dart';

/// [DefaultVideoPlayerService] manages native video playback surfaces and streams.
///
/// ============================================================================
/// ARCHITECTURAL RATIONALE & MEMORY MANAGEMENT:
/// ============================================================================
/// 1. Single-Instance GPU Protection:
///    - Initializing multiple video decoders simultaneously causes Out-Of-Memory (OOM)
///      crashes on 2GB RAM budget phones.
///    - Before allocating a new [VideoPlayerController], [_disposeCurrentController]
///      is guaranteed to run, freeing previous native GPU surfaces and buffers.
///
/// 2. Stream-Based Reactive State:
///    - Adapts native [ValueNotifier] events from [VideoPlayerController] into an
///      immutable [Stream<VideoPlaybackState>], upholding Clean Architecture boundaries.
/// ============================================================================
class DefaultVideoPlayerService implements IVideoPlayerService {
  VideoPlayerController? _controller;
  final StreamController<VideoPlaybackState> _stateController =
      StreamController<VideoPlaybackState>.broadcast();
  VideoPlaybackState _currentState = const VideoPlaybackState();

  /// Exposes the active native controller for presentation rendering
  VideoPlayerController? get activeController => _controller;

  @override
  Stream<VideoPlaybackState> get stateStream => _stateController.stream;

  void _emitState(VideoPlaybackState state) {
    _currentState = state;
    if (!_stateController.isClosed) {
      _stateController.add(_currentState);
    }
  }

  @override
  Future<void> initialize(String videoUrl) async {
    try {
      debugPrint('[VideoPlayer] Initializing video: $videoUrl');
      _emitState(_currentState.copyWith(status: VideoStatus.loading));

      // Free previous GPU texture to prevent memory accumulation
      await _disposeCurrentController();

      final uri = Uri.parse(videoUrl);
      _controller = VideoPlayerController.networkUrl(uri);

      await _controller!.initialize();
      _controller!.addListener(_onControllerUpdate);

      final duration = _controller!.value.duration;
      final aspect = _controller!.value.aspectRatio;

      debugPrint(
        '[VideoPlayer] Initialized successfully. Duration: $duration, AspectRatio: $aspect',
      );

      _emitState(
        _currentState.copyWith(
          status: VideoStatus.paused,
          duration: duration,
          aspectRatio: aspect > 0 ? aspect : 16 / 9,
        ),
      );
    } catch (e, stack) {
      debugPrint('[VideoPlayer] ERROR initializing video: $e\n$stack');
      _emitState(
        _currentState.copyWith(
          status: VideoStatus.error,
          errorMessage: 'تعذر تحميل الفيديو، يرجى التحقق من اتصال الإنترنت',
        ),
      );
    }
  }

  void _onControllerUpdate() {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final value = _controller!.value;
    final position = value.position;
    final duration = value.duration;
    final isPlaying = value.isPlaying;
    final isBuffering = value.isBuffering;
    final isCompleted = position >= duration && duration > Duration.zero;

    // Calculate buffered range
    Duration buffered = Duration.zero;
    if (value.buffered.isNotEmpty) {
      buffered = value.buffered.last.end;
    }

    VideoStatus status;
    if (value.hasError) {
      status = VideoStatus.error;
    } else if (isBuffering) {
      status = VideoStatus.loading;
    } else if (isCompleted) {
      status = VideoStatus.completed;
    } else if (isPlaying) {
      status = VideoStatus.playing;
    } else {
      status = VideoStatus.paused;
    }

    _emitState(
      _currentState.copyWith(
        status: status,
        position: position,
        duration: duration,
        bufferedPosition: buffered,
        errorMessage: value.errorDescription,
      ),
    );
  }

  @override
  Future<void> play() async {
    if (_controller != null && _controller!.value.isInitialized) {
      // If completed, loop from start
      if (_currentState.status == VideoStatus.completed) {
        await _controller!.seekTo(Duration.zero);
      }
      await _controller!.play();
    }
  }

  @override
  Future<void> pause() async {
    if (_controller != null && _controller!.value.isInitialized) {
      await _controller!.pause();
    }
  }

  @override
  Future<void> seek(Duration position) async {
    if (_controller != null && _controller!.value.isInitialized) {
      await _controller!.seekTo(position);
    }
  }

  @override
  Future<void> setControlsVisibility(bool isVisible) async {
    _emitState(_currentState.copyWith(isControlsVisible: isVisible));
  }

  Future<void> _disposeCurrentController() async {
    if (_controller != null) {
      _controller!.removeListener(_onControllerUpdate);
      await _controller!.dispose();
      _controller = null;
    }
  }

  @override
  Future<void> dispose() async {
    await _disposeCurrentController();
    await _stateController.close();
  }
}
