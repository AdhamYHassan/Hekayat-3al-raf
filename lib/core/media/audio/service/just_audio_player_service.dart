// ignore_for_file: experimental_member_use

import 'dart:async';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:hekayat_3al_raf/core/media/audio/model/audio_playback_state.dart';
import 'package:hekayat_3al_raf/core/media/audio/model/audio_track.dart';
import 'package:hekayat_3al_raf/core/media/audio/service/i_audio_player_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

/// [JustAudioPlayerService] implements [IAudioPlayerService] using an architectural
/// pattern designed for 1M+ scale:
/// 1. "Smart Singleton with Lazy Virtual Re-instantiation" (Native Decoders Auto-Release).
/// 2. "LockCachingAudioSource" (Dual-Stream Zero-Latency Streaming + Background Disk Caching).
/// 3. "Audio Focus & Becoming Noisy Interruption Handling" (Auto-pause on unplugged headphones/calls).
///
/// ============================================================================
/// ENGINEERING RATIONALE & ARCHITECTURAL HIGHLIGHTS:
/// ============================================================================
/// 1. Audio Focus & Becoming Noisy (Safety & UX):
///    - Listens to [AudioSession.becomingNoisyEventStream]: automatically pauses
///      playback when headphones or AirPods disconnect, preventing unexpected
///      loudspeaker audio in quiet public environments.
///    - Listens to [AudioSession.interruptionEventStream]: gracefully pauses on
///      incoming phone calls and resumes when the call concludes without user friction.
///
/// 2. Dual-Stream Caching Architecture:
///    - Instead of discarding raw audio bytes after memory decoding, [LockCachingAudioSource]
///      splits the incoming network stream into two concurrent pipelines:
///      * Pipeline A: Directly pipes chunks to the native audio decoder for immediate playback.
///      * Pipeline B: Concurrently writes chunks into a dedicated temporary cache file.
///    - Next time the same story is requested, it bypasses the internet completely,
///      playing locally with Zero Latency and saving 100% of user data.
///
/// 3. Memory & Storage Safety:
///    - Caches are stored inside [getTemporaryDirectory], allowing the operating system
///      (iOS/Android) to safely reclaim disk space if the device runs low on storage.
///
/// 4. Soft Pause vs. Hard Release:
///    - 5-minute inactivity timer disposes the underlying [_player] to free native audio
///      ports while preserving state for zero-crash resurrection.
/// ============================================================================
class JustAudioPlayerService implements IAudioPlayerService {
  AudioPlayer? _player;
  final StreamController<AudioPlaybackState> _stateController =
      StreamController<AudioPlaybackState>.broadcast();
  AudioPlaybackState _currentState = const AudioPlaybackState();

  // Internal stream subscriptions list to ensure clean cancellation upon hard release
  final List<StreamSubscription> _subscriptions = [];
  final List<StreamSubscription> _sessionSubscriptions = [];

  // Inactivity threshold: release native decoders after 5 minutes of paused/idle state
  Timer? _idleTimer;
  static const Duration _idleReleaseThreshold = Duration(minutes: 5);

  // Cached metadata for seamless virtual resurrection
  AudioTrack? _lastTrack;
  Duration _lastPosition = Duration.zero;

  JustAudioPlayerService() {
    _initAudioSession();
    _ensurePlayer();
  }

  /// Configures Apple/Android audio session for music/story streaming
  /// Handles "Becoming Noisy" (headphone unplugging) and incoming phone call interruptions.
  Future<void> _initAudioSession() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());

      // 1. Handle Becoming Noisy: Disconnecting headphones should pause playback immediately
      _sessionSubscriptions.add(
        session.becomingNoisyEventStream.listen((_) {
          debugPrint(
            '[AudioSession] Becoming Noisy detected (headphones disconnected). Pausing playback.',
          );
          pause();
        }),
      );

      // 2. Handle Audio Interruptions: Phone calls or navigation alerts
      _sessionSubscriptions.add(
        session.interruptionEventStream.listen((event) {
          if (event.begin) {
            debugPrint('[AudioSession] Interruption began (e.g. Incoming call). Pausing.');
            pause();
          } else {
            debugPrint('[AudioSession] Interruption ended. Resuming playback if appropriate.');
            if (event.type == AudioInterruptionType.pause) {
              resume();
            }
          }
        }),
      );
    } catch (e) {
      debugPrint('[AudioPlayer] AudioSession config error: $e');
    }
  }

  /// Lazily provisions a fresh [AudioPlayer] instance if none exists or if
  /// the previous instance was released due to idle timeout.
  AudioPlayer _ensurePlayer() {
    if (_player == null) {
      debugPrint('[AudioPlayer] Provisioning fresh native AudioPlayer instance');
      _player = AudioPlayer();
      _initStreams();
    }
    return _player!;
  }

  /// Binds stream listeners to observe playback changes and emit immutable states
  void _initStreams() {
    _cancelSubscriptions();
    final p = _player!;

    _subscriptions.add(
      p.playbackEventStream.listen(
        (event) => debugPrint('[AudioPlayer Event] state: ${event.processingState}'),
        onError: (Object e) => debugPrint('[AudioPlayer Event ERROR] $e'),
      ),
    );

    // Track current position and store locally for potential resurrection
    _subscriptions.add(
      p.positionStream.listen((position) {
        _lastPosition = position;
        _emitState(_currentState.copyWith(position: position));
      }),
    );

    // Track duration updates
    _subscriptions.add(
      p.durationStream.listen((duration) {
        if (duration != null) {
          _emitState(_currentState.copyWith(duration: duration));
        }
      }),
    );

    // Track network buffering progress
    _subscriptions.add(
      p.bufferedPositionStream.listen((buffered) {
        _emitState(_currentState.copyWith(bufferedPosition: buffered));
      }),
    );

    // Track state transitions (idle, loading, playing, paused, completed)
    _subscriptions.add(
      p.playerStateStream.listen((playerState) {
        AudioStatus newStatus;
        if (playerState.processingState == ProcessingState.idle) {
          newStatus = AudioStatus.initial;
        } else if (playerState.processingState == ProcessingState.loading ||
            playerState.processingState == ProcessingState.buffering) {
          newStatus = AudioStatus.loading;
        } else if (playerState.processingState == ProcessingState.completed) {
          newStatus = AudioStatus.completed;
          _scheduleIdleRelease();
        } else if (playerState.playing) {
          newStatus = AudioStatus.playing;
          _cancelIdleTimer();
        } else {
          newStatus = AudioStatus.paused;
          _scheduleIdleRelease();
        }
        _emitState(_currentState.copyWith(status: newStatus));
      }),
    );
  }

  /// Schedules a hard release of native resources after [_idleReleaseThreshold]
  void _scheduleIdleRelease() {
    _cancelIdleTimer();
    _idleTimer = Timer(_idleReleaseThreshold, () {
      debugPrint(
        '[AudioPlayer] Idle threshold reached (5m). Releasing native decoders to preserve RAM & battery.',
      );
      _releaseNativePlayer();
    });
  }

  /// Cancels any pending idle release timer
  void _cancelIdleTimer() {
    _idleTimer?.cancel();
    _idleTimer = null;
  }

  /// Disposes the underlying native player without closing the public service stream
  Future<void> _releaseNativePlayer() async {
    _cancelSubscriptions();
    await _player?.dispose();
    _player = null;
  }

  void _cancelSubscriptions() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    _subscriptions.clear();
  }

  void _emitState(AudioPlaybackState state) {
    _currentState = state;
    if (!_stateController.isClosed) {
      _stateController.add(_currentState);
    }
  }

  @override
  Stream<AudioPlaybackState> get stateStream => _stateController.stream;

  /// Resolves the local cache file path for a given audio track
  Future<File> _resolveCacheFile(String trackId) async {
    final tempDir = await getTemporaryDirectory();
    final audioCacheDir = Directory('${tempDir.path}/audio_cache');
    if (!await audioCacheDir.exists()) {
      await audioCacheDir.create(recursive: true);
    }
    // Sanitize trackId into a safe filesystem name
    final safeName = trackId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    return File('${audioCacheDir.path}/$safeName.mp3');
  }

  @override
  Future<void> playTrack(AudioTrack track) async {
    try {
      _cancelIdleTimer();
      _lastTrack = track;
      final player = _ensurePlayer();

      debugPrint('[AudioPlayer] Loading Track with Caching: ${track.title}');
      _emitState(_currentState.copyWith(status: AudioStatus.loading));

      // Resolve local cache destination
      final cacheFile = await _resolveCacheFile(track.id);
      debugPrint('[AudioPlayer] Cache destination: ${cacheFile.path}');

      final mediaItem = MediaItem(
        id: track.id,
        album: track.category,
        title: track.title,
        artist: track.narrator,
        artUri: track.artworkUrl != null ? Uri.parse(track.artworkUrl!) : null,
      );

      // 1. Pure Offline Check: If file is fully downloaded, stream directly from disk
      AudioSource audioSource;
      final isCached = await cacheFile.exists() && await cacheFile.length() > 0;

      if (isCached) {
        debugPrint('[AudioPlayer] Cache HIT: Playing directly from local storage (Zero Network).');
        audioSource = AudioSource.file(
          cacheFile.path,
          tag: mediaItem,
        );
      } else {
        debugPrint('[AudioPlayer] Cache MISS: Checking connectivity before network streaming...');
        // Pre-flight connectivity check to avoid unhandled proxy socket crashes when offline
        try {
          final uri = Uri.parse(track.url);
          final result = await InternetAddress.lookup(uri.host)
              .timeout(const Duration(seconds: 2));
          if (result.isEmpty || result[0].rawAddress.isEmpty) {
            throw const SocketException('No address associated with hostname');
          }
        } catch (_) {
          debugPrint('[AudioPlayer] Pre-flight Offline Check: No active internet connection.');
          _emitState(
            _currentState.copyWith(
              status: AudioStatus.error,
              errorMessage: 'لا يوجد اتصال بالإنترنت للاستماع لأول مرة',
            ),
          );
          return;
        }

        debugPrint('[AudioPlayer] Network verified. Streaming over network with LockCaching.');
        audioSource = LockCachingAudioSource(
          Uri.parse(track.url),
          cacheFile: cacheFile,
          tag: mediaItem,
        );
      }

      final duration = await player.setAudioSource(audioSource);
      debugPrint('[AudioPlayer] Duration resolved: $duration');
      await player.play();
      debugPrint('[AudioPlayer] Playback started successfully');
    } on SocketException catch (e) {
      debugPrint('[AudioPlayer] Offline SocketException: No network connection available: $e');
      _emitState(
        _currentState.copyWith(
          status: AudioStatus.error,
          errorMessage: 'لا يوجد اتصال بالإنترنت للاستماع لأول مرة',
        ),
      );
    } catch (e, stack) {
      debugPrint('[AudioPlayer] ERROR playing track: $e\n$stack');
      final isNetworkError = e.toString().contains('Failed host lookup') ||
          e.toString().contains('SocketException') ||
          e.toString().contains('HttpException');

      _emitState(
        _currentState.copyWith(
          status: AudioStatus.error,
          errorMessage: isNetworkError
              ? 'لا يوجد اتصال بالإنترنت للاستماع لأول مرة'
              : 'تعذر تشغيل التسجيل الصوتي، يرجى المحاولة لاحقاً',
        ),
      );
    }
  }

  @override
  Future<void> playUrl(String url) async {
    await playTrack(
      AudioTrack(
        id: url,
        url: url,
        title: 'حكاية صوتية',
        narrator: 'حكايات على الرف',
      ),
    );
  }

  @override
  Future<void> resume() async {
    _cancelIdleTimer();
    if (_player == null && _lastTrack != null) {
      // Seamless resurrection: re-instantiate, reload track, and restore position
      final player = _ensurePlayer();
      await playTrack(_lastTrack!);
      if (_lastPosition > Duration.zero) {
        await player.seek(_lastPosition);
      }
    } else {
      await _player?.play();
    }
  }

  @override
  Future<void> pause() async {
    await _player?.pause();
    _scheduleIdleRelease();
  }

  @override
  Future<void> seek(Duration position) async {
    _lastPosition = position;
    await _player?.seek(position);
  }

  @override
  Future<void> stop() async {
    await _player?.stop();
    _scheduleIdleRelease();
  }

  @override
  Future<void> dispose() async {
    _cancelIdleTimer();
    _cancelSubscriptions();
    for (final sub in _sessionSubscriptions) {
      sub.cancel();
    }
    _sessionSubscriptions.clear();
    await _player?.dispose();
    _player = null;
    await _stateController.close();
  }
}
