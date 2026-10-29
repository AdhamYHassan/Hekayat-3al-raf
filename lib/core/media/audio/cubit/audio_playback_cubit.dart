import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/audio_playback_state.dart';
import '../model/audio_track.dart';
import '../service/i_audio_player_service.dart';

class AudioPlayerCubit extends Cubit<AudioPlaybackState> {
  final IAudioPlayerService _audioService;
  StreamSubscription<AudioPlaybackState>? _stateSubscription;
  String? _currentTrackId;

  AudioPlayerCubit(this._audioService) : super(const AudioPlaybackState()) {
    _subscribeToAudioService();
  }

  void _subscribeToAudioService() {
    _stateSubscription = _audioService.stateStream.listen((playbackState) {
      emit(playbackState);
    });
  }

  /// Start a track or toggle pause/resume with rich metadata support
  Future<void> playOrToggleTrack(AudioTrack track) async {
    if (_currentTrackId != track.id ||
        state.status == AudioStatus.initial ||
        state.status == AudioStatus.completed) {
      _currentTrackId = track.id;
      await _audioService.playTrack(track);
    } else if (state.status == AudioStatus.playing) {
      await _audioService.pause();
    } else if (state.status == AudioStatus.paused) {
      await _audioService.resume();
    }
  }

  /// Backward-compatible URL helper
  Future<void> playOrToggle(String audioUrl) async {
    await playOrToggleTrack(
      AudioTrack(
        id: audioUrl,
        url: audioUrl,
        title: 'حكاية صوتية',
        narrator: 'حكايات على الرف',
      ),
    );
  }

  /// Seek audio position (drag drop)
  Future<void> seek(Duration position) async {
    await _audioService.seek(position);
  }

  Future<void> pause() async {
    await _audioService.pause();
  }

  @override
  Future<void> close() async {
    await _stateSubscription?.cancel();
    await _audioService.dispose();
    return super.close();
  }
}
