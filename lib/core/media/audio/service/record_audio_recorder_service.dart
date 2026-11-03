import 'dart:async';
import 'package:record/record.dart';
import 'package:hekayat_3al_raf/core/media/audio/service/i_audio_recorder_service.dart';

class RecordAudioRecorderService implements IAudioRecorderService {
  final AudioRecorder _recorder;
  StreamController<double>? _amplitudeController;
  Timer? _amplitudeTimer;

  RecordAudioRecorderService([AudioRecorder? recorder])
      : _recorder = recorder ?? AudioRecorder();

  @override
  Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  @override
  Future<void> start(String path) async {
    // 128 kbps AAC-LC: Studio clarity at ~1MB per minute, 100% native encoding
    const config = RecordConfig(
      encoder: AudioEncoder.aacLc,
      bitRate: 128000,
      sampleRate: 44100,
      numChannels: 1, // Mono voice recording is ideal for podcasts and storytelling
    );

    await _recorder.start(config, path: path);
    _startAmplitudePolling();
  }

  @override
  Future<void> pause() async {
    await _recorder.pause();
    _stopAmplitudePolling();
  }

  @override
  Future<void> resume() async {
    await _recorder.resume();
    _startAmplitudePolling();
  }

  @override
  Future<String?> stop() async {
    _stopAmplitudePolling();
    return await _recorder.stop();
  }

  @override
  Future<void> cancel() async {
    _stopAmplitudePolling();
    await _recorder.cancel();
  }

  @override
  Future<bool> isRecording() async {
    return await _recorder.isRecording();
  }

  @override
  Future<bool> isPaused() async {
    return await _recorder.isPaused();
  }

  @override
  Stream<double> get amplitudeStream {
    _amplitudeController ??= StreamController<double>.broadcast();
    return _amplitudeController!.stream;
  }

  void _startAmplitudePolling() {
    _stopAmplitudePolling();
    // 50ms polling = 20 samples/sec for responsive & fluid voice waves
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 50), (_) async {
      if (await _recorder.isRecording()) {
        final amp = await _recorder.getAmplitude();
        // Normalize dB (-60 to 0) to a positive scale (0.0 to 1.0)
        final current = amp.current;
        final normalized = ((current + 60) / 60).clamp(0.0, 1.0);
        _amplitudeController?.add(normalized);
      }
    });
  }

  void _stopAmplitudePolling() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;
  }

  @override
  Future<void> dispose() async {
    _stopAmplitudePolling();
    await _amplitudeController?.close();
    _amplitudeController = null;
    await _recorder.dispose();
  }
}

