import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:hekayat_3al_raf/core/media/audio/model/audio_playback_state.dart';
import 'package:hekayat_3al_raf/core/media/audio/model/audio_track.dart';
import 'package:hekayat_3al_raf/core/media/audio/service/i_audio_player_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class JustAudioPlayerService implements IAudioPlayerService {
  final AudioPlayer _player;
  final StreamController<AudioPlaybackState> _stateController =
      StreamController<AudioPlaybackState>.broadcast();
  AudioPlaybackState _currentState = const AudioPlaybackState();

  JustAudioPlayerService({AudioPlayer? player})
    : _player = player ?? AudioPlayer() {
    _initAudioSession();
    _initStreams();
  }

  Future<void> _initAudioSession() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(
        const AudioSessionConfiguration.music(),
      );
    } catch (e) {
      debugPrint('[AudioPlayer] AudioSession config error: $e');
    }
  }

  void _initStreams() {
    _player.playbackEventStream.listen(
      (event) {
        debugPrint('[AudioPlayer Event] state: ${event.processingState}');
      },
      onError: (Object e, StackTrace st) {
        debugPrint('[AudioPlayer Event ERROR] $e');
      },
    );

    // 1. Listening for changes in the audio position (Current Position)
    _player.positionStream.listen((position) {
      _emitState(_currentState.copyWith(position: position));
    });

    // 2. Listening for changes to the file's total duration
    _player.durationStream.listen((duration) {
      if (duration != null) {
        debugPrint('[AudioPlayer] Duration received: $duration');
        _emitState(_currentState.copyWith(duration: duration));
      }
    });

    // 3. Listening for pre-caching (Buffered Position)
    _player.bufferedPositionStream.listen((buffered) {
      _emitState(_currentState.copyWith(bufferedPosition: buffered));
    });

    // 4. Listening for the playback state (Playing / Paused / Buffering)
    _player.playerStateStream.listen((playerState) {
      debugPrint(
        '[AudioPlayer] playerState: playing=${playerState.playing}, processing=${playerState.processingState}',
      );
      AudioStatus newStatus;
      if (playerState.processingState == ProcessingState.idle) {
        newStatus = AudioStatus.initial;
      } else if (playerState.processingState == ProcessingState.loading ||
          playerState.processingState == ProcessingState.buffering) {
        newStatus = AudioStatus.loading;
      } else if (playerState.processingState == ProcessingState.completed) {
        newStatus = AudioStatus.completed;
      } else if (playerState.playing) {
        newStatus = AudioStatus.playing;
      } else {
        newStatus = AudioStatus.paused;
      }
      _emitState(_currentState.copyWith(status: newStatus));
    });
  }

  void _emitState(AudioPlaybackState state) {
    _currentState = state;
    if (!_stateController.isClosed) {
      _stateController.add(_currentState);
    }
  }

  @override
  Stream<AudioPlaybackState> get stateStream => _stateController.stream;

  @override
  Future<void> playTrack(AudioTrack track) async {
    try {
      debugPrint('[AudioPlayer] Loading Track: ${track.title} | ${track.url}');
      _emitState(_currentState.copyWith(status: AudioStatus.loading));

      // AudioSource with lockscreen / background metadata
      final audioSource = AudioSource.uri(
        Uri.parse(track.url),
        tag: MediaItem(
          id: track.id,
          album: track.category,
          title: track.title,
          artist: track.narrator,
          artUri: track.artworkUrl != null ? Uri.parse(track.artworkUrl!) : null,
        ),
      );

      final duration = await _player.setAudioSource(audioSource);
      debugPrint('[AudioPlayer] Duration resolved from setAudioSource: $duration');
      await _player.play();
      debugPrint('[AudioPlayer] Playback started successfully');
    } catch (e, stack) {
      debugPrint('[AudioPlayer] ERROR playing track: $e\n$stack');
      _emitState(
        _currentState.copyWith(
          status: AudioStatus.error,
          errorMessage: e.toString(),
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
  Future<void> resume() async => await _player.play();
  @override
  Future<void> pause() async => await _player.pause();
  @override
  Future<void> seek(Duration position) async => await _player.seek(position);
  @override
  Future<void> stop() async => await _player.stop();
  @override
  Future<void> dispose() async {
    await _player.dispose();
    await _stateController.close();
  }
}
