abstract class IAudioRecorderService {
  Future<bool> hasPermission();
  Future<void> start(String path);
  Future<void> pause();
  Future<void> resume();
  Future<String?> stop();
  Future<void> cancel();
  Future<bool> isRecording();
  Future<bool> isPaused();
  Stream<double> get amplitudeStream;
  Future<void> dispose();
}

