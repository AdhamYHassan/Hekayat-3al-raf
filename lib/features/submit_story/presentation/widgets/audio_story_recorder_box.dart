import 'dart:async';
import 'dart:io';
import 'package:hekayat_3al_raf/core/widgets/app_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/media/audio/model/audio_playback_state.dart';
import 'package:hekayat_3al_raf/core/media/audio/model/audio_track.dart';
import 'package:hekayat_3al_raf/core/media/audio/service/i_audio_player_service.dart';
import 'package:hekayat_3al_raf/core/media/audio/service/i_audio_recorder_service.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';

enum AudioRecordingUiStatus { idle, recording, paused, recorded }

class AudioStoryRecorderBox extends StatefulWidget {
  final String? initialAudioPath;
  final int initialDurationSeconds;
  final Function(String path, int durationSeconds) onRecordingCompleted;
  final VoidCallback onRecordingCleared;

  const AudioStoryRecorderBox({
    super.key,
    this.initialAudioPath,
    this.initialDurationSeconds = 0,
    required this.onRecordingCompleted,
    required this.onRecordingCleared,
  });

  @override
  State<AudioStoryRecorderBox> createState() => _AudioStoryRecorderBoxState();
}

class _AudioStoryRecorderBoxState extends State<AudioStoryRecorderBox> {
  late final IAudioRecorderService _recorderService;
  late final IAudioPlayerService _audioPlayerService;

  AudioRecordingUiStatus _uiStatus = AudioRecordingUiStatus.idle;
  String? _currentAudioPath;

  // Dragging state for smooth seekbar UX (prevents stutter / position jumping)
  bool _isDragging = false;
  double _dragPositionMs = 0.0;

  // High-Frequency Leaf Notifiers (Zero Lag / 120 FPS)
  late final ValueNotifier<int> _secondsNotifier;
  late final ValueNotifier<List<double>> _waveformNotifier;
  late final ValueNotifier<bool> _isPlayingPreviewNotifier;
  late final ValueNotifier<Duration> _playbackPositionNotifier;
  late final ValueNotifier<Duration> _playbackTotalDurationNotifier;

  Timer? _timer;
  StreamSubscription<double>? _amplitudeSubscription;
  StreamSubscription<AudioPlaybackState>? _playerStateSubscription;

  static const int _waveformBarCount = 36;

  @override
  void initState() {
    super.initState();
    _recorderService = getIt<IAudioRecorderService>();
    _audioPlayerService = getIt<IAudioPlayerService>();

    _secondsNotifier = ValueNotifier<int>(widget.initialDurationSeconds);
    _waveformNotifier = ValueNotifier<List<double>>(
      List.filled(_waveformBarCount, 0.15),
    );
    _isPlayingPreviewNotifier = ValueNotifier<bool>(false);
    _playbackPositionNotifier = ValueNotifier<Duration>(Duration.zero);
    _playbackTotalDurationNotifier = ValueNotifier<Duration>(
      Duration(seconds: widget.initialDurationSeconds),
    );

    if (widget.initialAudioPath != null &&
        widget.initialAudioPath!.isNotEmpty &&
        File(widget.initialAudioPath!).existsSync()) {
      _currentAudioPath = widget.initialAudioPath;
      _uiStatus = AudioRecordingUiStatus.recorded;
    }

    _listenToPlayerStreams();
  }

  void _listenToPlayerStreams() {
    _playerStateSubscription = _audioPlayerService.stateStream.listen((state) {
      final isPlayingThis = state.status == AudioStatus.playing;
      _isPlayingPreviewNotifier.value = isPlayingThis;

      // When user is dragging, do not overwrite the position notifier from playback stream
      if (!_isDragging && state.position > Duration.zero) {
        _playbackPositionNotifier.value = state.position;
      }
      if (state.duration > Duration.zero) {
        _playbackTotalDurationNotifier.value = state.duration;
      }
      if (state.status == AudioStatus.completed) {
        _isPlayingPreviewNotifier.value = false;
        _playbackPositionNotifier.value = Duration.zero;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _amplitudeSubscription?.cancel();
    _playerStateSubscription?.cancel();

    _audioPlayerService.stop();

    _secondsNotifier.dispose();
    _waveformNotifier.dispose();
    _isPlayingPreviewNotifier.dispose();
    _playbackPositionNotifier.dispose();
    _playbackTotalDurationNotifier.dispose();

    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> _startRecording() async {
    final hasPerm = await _recorderService.hasPermission();
    if (!hasPerm) {
      if (mounted) {
        AppSnackBar.showError(
          context,
          message: 'submit.recorder.permission_required'.tr(),
        );
      }
      return;
    }

    final tempDir = await getTemporaryDirectory();
    final fileName = 'story_rec_${DateTime.now().millisecondsSinceEpoch}.m4a';
    final filePath = '${tempDir.path}/$fileName';

    await _recorderService.start(filePath);

    _currentAudioPath = filePath;
    _secondsNotifier.value = 0;
    _waveformNotifier.value = List.filled(_waveformBarCount, 0.15);

    _amplitudeSubscription?.cancel();
    _amplitudeSubscription = _recorderService.amplitudeStream.listen((amp) {
      // WhatsApp style: stream sliding bars from left to right (or right to left)
      final currentList = List<double>.from(_waveformNotifier.value);
      currentList.removeAt(0);
      currentList.add(amp.clamp(0.12, 1.0));
      _waveformNotifier.value = currentList;
    });

    _startTimer();

    setState(() {
      _uiStatus = AudioRecordingUiStatus.recording;
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _secondsNotifier.value++;
    });
  }

  Future<void> _pauseRecording() async {
    await _recorderService.pause();
    _timer?.cancel();
    setState(() {
      _uiStatus = AudioRecordingUiStatus.paused;
    });
  }

  Future<void> _resumeRecording() async {
    await _recorderService.resume();
    _startTimer();
    setState(() {
      _uiStatus = AudioRecordingUiStatus.recording;
    });
  }

  Future<void> _stopRecording() async {
    debugPrint('AudioStoryRecorderBox: Stopping recording...');
    _timer?.cancel();
    _amplitudeSubscription?.cancel();

    final path = await _recorderService.stop();
    debugPrint(
      'AudioStoryRecorderBox: Recorder stopped. Returned path: $path, current: $_currentAudioPath',
    );
    final finalPath = path ?? _currentAudioPath;
    final duration = _secondsNotifier.value;

    if (finalPath != null && File(finalPath).existsSync()) {
      final size = File(finalPath).lengthSync();
      debugPrint(
        'AudioStoryRecorderBox: Valid recording file found! Path: $finalPath, Size: $size bytes, Duration: ${duration}s',
      );
      _currentAudioPath = finalPath;
      widget.onRecordingCompleted(finalPath, duration);

      setState(() {
        _uiStatus = AudioRecordingUiStatus.recorded;
      });
    } else {
      debugPrint(
        'AudioStoryRecorderBox: Failed to find valid recorded file at path: $finalPath',
      );
      setState(() {
        _uiStatus = AudioRecordingUiStatus.idle;
      });
    }
  }

  Future<void> _deleteRecording() async {
    _timer?.cancel();
    _amplitudeSubscription?.cancel();
    await _audioPlayerService.stop();

    if (_uiStatus == AudioRecordingUiStatus.recording ||
        _uiStatus == AudioRecordingUiStatus.paused) {
      await _recorderService.cancel();
    }

    if (_currentAudioPath != null) {
      final file = File(_currentAudioPath!);
      if (file.existsSync()) {
        try {
          file.deleteSync();
        } catch (_) {}
      }
    }

    _currentAudioPath = null;
    _secondsNotifier.value = 0;
    widget.onRecordingCleared();

    setState(() {
      _uiStatus = AudioRecordingUiStatus.idle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: ColorManager.primaryLight.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _uiStatus == AudioRecordingUiStatus.recording
              ? ColorManager.gold
              : ColorManager.gold.withValues(alpha: 0.15),
          width: _uiStatus == AudioRecordingUiStatus.recording ? 1.5 : 1.0,
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: switch (_uiStatus) {
          AudioRecordingUiStatus.idle => _buildIdleView(),
          AudioRecordingUiStatus.recording ||
          AudioRecordingUiStatus.paused => _buildActiveRecordingView(),
          AudioRecordingUiStatus.recorded => _buildPreviewPlayerView(),
        },
      ),
    );
  }

  // 1. Idle View: Start Recording
  Widget _buildIdleView() {
    return Column(
      key: const ValueKey('idle_view'),
      children: [
        GestureDetector(
          onTap: _startRecording,
          child: Container(
            width: 72.r,
            height: 72.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFE8CB7D), Color(0xFFC9A24B)],
              ),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.gold.withValues(alpha: 0.25),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              CupertinoIcons.mic_fill,
              color: ColorManager.primaryDark,
              size: 32.sp,
            ),
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          'submit.recorder.start_prompt'.tr(),
          style: GoogleFonts.alexandria(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: ColorManager.paper100,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'submit.recorder.start_subtitle'.tr(),
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 11.5.sp,
            color: ColorManager.paper400,
          ),
        ),
      ],
    );
  }

  // 2. Active View: Recording & Paused with Waveform and Leaf Timer
  Widget _buildActiveRecordingView() {
    final isPaused = _uiStatus == AudioRecordingUiStatus.paused;

    return Column(
      key: const ValueKey('active_recording_view'),
      children: [
        // Top Row: Status Indicator & Timer
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 10.r,
                  height: 10.r,
                  decoration: BoxDecoration(
                    color: isPaused ? ColorManager.warning : ColorManager.error,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  isPaused
                      ? 'submit.recorder.paused'.tr()
                      : 'submit.recorder.recording_now'.tr(),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isPaused
                        ? ColorManager.warning
                        : ColorManager.paper100,
                  ),
                ),
              ],
            ),
            // High-Performance Leaf Timer Notifier
            ValueListenableBuilder<int>(
              valueListenable: _secondsNotifier,
              builder: (context, seconds, _) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryDark,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: ColorManager.gold.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Text(
                    _formatTime(seconds),
                    style: GoogleFonts.ibmPlexSansArabic(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.goldLight,
                    ),
                  ),
                );
              },
            ),
          ],
        ),

        SizedBox(height: 18.h),

        // Live Audio Amplitude Waveform (WhatsApp-style real-time scrolling bars)
        ValueListenableBuilder<List<double>>(
          valueListenable: _waveformNotifier,
          builder: (context, bars, _) {
            return Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: ColorManager.primaryDark.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isPaused
                      ? ColorManager.paper400.withValues(alpha: 0.15)
                      : ColorManager.gold.withValues(alpha: 0.25),
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: bars.map((heightRatio) {
                  final barHeight = isPaused
                      ? (44.h * 0.15)
                      : (44.h * heightRatio.clamp(0.12, 1.0));

                  return Expanded(
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 60),
                        curve: Curves.easeOutQuad,
                        width: 3.w,
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: isPaused
                              ? ColorManager.paper400.withValues(alpha: 0.3)
                              : ColorManager.gold,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),

        SizedBox(height: 20.h),

        // Controls: Pause/Resume + Done + Delete
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Delete / Discard Button
            IconButton(
              onPressed: _deleteRecording,
              icon: Icon(
                CupertinoIcons.trash,
                color: ColorManager.error,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 16.w),

            // Pause / Resume Toggle
            GestureDetector(
              onTap: isPaused ? _resumeRecording : _pauseRecording,
              child: Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorManager.primaryDark,
                  border: Border.all(color: ColorManager.gold, width: 1.5),
                ),
                child: Icon(
                  isPaused
                      ? CupertinoIcons.play_fill
                      : CupertinoIcons.pause_fill,
                  color: ColorManager.gold,
                  size: 20.sp,
                ),
              ),
            ),
            SizedBox(width: 16.w),

            // Done / Finish Button
            ElevatedButton.icon(
              onPressed: _stopRecording,
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.gold,
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                elevation: 0,
              ),
              icon: Icon(
                CupertinoIcons.checkmark_alt,
                color: ColorManager.primaryDark,
                size: 18.sp,
              ),
              label: Text(
                'submit.recorder.save_recording'.tr(),
                style: GoogleFonts.alexandria(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.primaryDark,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 3. Preview Player View: Listen to what was recorded
  Widget _buildPreviewPlayerView() {
    return Column(
      key: const ValueKey('preview_player_view'),
      children: [
        Row(
          children: [
            Icon(
              CupertinoIcons.waveform_path,
              color: ColorManager.gold,
              size: 20.sp,
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'submit.recorder.ready_for_review'.tr(),
                style: GoogleFonts.alexandria(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.paper100,
                ),
              ),
            ),
            IconButton(
              onPressed: _deleteRecording,
              icon: Icon(
                CupertinoIcons.trash,
                color: ColorManager.paper400,
                size: 18.sp,
              ),
            ),
          ],
        ),

        SizedBox(height: 10.h),

        // Audio Progress Seekbar
        ValueListenableBuilder<Duration>(
          valueListenable: _playbackTotalDurationNotifier,
          builder: (context, totalDuration, _) {
            return ValueListenableBuilder<Duration>(
              valueListenable: _playbackPositionNotifier,
              builder: (context, position, _) {
                final totalMs = totalDuration.inMilliseconds.toDouble();
                final maxSliderValue = totalMs > 0 ? totalMs : 1.0;

                final currentSliderValue = _isDragging
                    ? _dragPositionMs.clamp(0.0, maxSliderValue)
                    : position.inMilliseconds.toDouble().clamp(
                        0.0,
                        maxSliderValue,
                      );

                final displayDuration = _isDragging
                    ? Duration(milliseconds: _dragPositionMs.toInt())
                    : position;

                return Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4.h,
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 6.r,
                        ),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 12.r,
                        ),
                        activeTrackColor: ColorManager.gold,
                        inactiveTrackColor: ColorManager.paper400.withValues(
                          alpha: 0.25,
                        ),
                        thumbColor: ColorManager.goldLight,
                      ),
                      child: Slider(
                        value: currentSliderValue,
                        min: 0.0,
                        max: maxSliderValue,
                        onChangeStart: (val) {
                          _isDragging = true;
                          _dragPositionMs = val;
                          _playbackPositionNotifier.value = Duration(
                            milliseconds: val.toInt(),
                          );
                        },
                        onChanged: (val) {
                          _dragPositionMs = val;
                          _playbackPositionNotifier.value = Duration(
                            milliseconds: val.toInt(),
                          );
                        },
                        onChangeEnd: (val) {
                          _isDragging = false;
                          _audioPlayerService.seek(
                            Duration(milliseconds: val.toInt()),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatTime(displayDuration.inSeconds),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 11.sp,
                              color: ColorManager.paper400,
                            ),
                          ),
                          Text(
                            _formatTime(totalDuration.inSeconds),
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 11.sp,
                              color: ColorManager.paper400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),

        SizedBox(height: 12.h),

        // Play/Pause & Re-record Actions
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Play / Pause Toggle Button
            ValueListenableBuilder<bool>(
              valueListenable: _isPlayingPreviewNotifier,
              builder: (context, isPlaying, _) {
                return GestureDetector(
                  onTap: () async {
                    debugPrint(
                      'AudioStoryRecorderBox: Play/Pause button tapped! Currently playing: $isPlaying, Path: $_currentAudioPath',
                    );
                    try {
                      if (isPlaying) {
                        debugPrint(
                          'AudioStoryRecorderBox: Pausing preview player...',
                        );
                        await _audioPlayerService.pause();
                      } else {
                        debugPrint(
                          'AudioStoryRecorderBox: Playing preview player...',
                        );
                        if (_currentAudioPath != null) {
                          await _audioPlayerService.playTrack(
                            AudioTrack(
                              id: _currentAudioPath!,
                              url: _currentAudioPath!,
                              title: 'submit.recorder.preview_title'.tr(),
                              narrator: 'submit.recorder.draft_narrator'.tr(),
                            ),
                          );
                        }
                        debugPrint(
                          'AudioStoryRecorderBox: Play command sent successfully!',
                        );
                      }
                    } catch (e, stack) {
                      debugPrint(
                        'AudioStoryRecorderBox: Error during play/pause: $e\n$stack',
                      );
                    }
                  },
                  child: Container(
                    width: 48.r,
                    height: 48.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE8CB7D), Color(0xFFC9A24B)],
                      ),
                    ),
                    child: Icon(
                      isPlaying
                          ? CupertinoIcons.pause_fill
                          : CupertinoIcons.play_fill,
                      color: ColorManager.primaryDark,
                      size: 22.sp,
                    ),
                  ),
                );
              },
            ),
            SizedBox(width: 14.w),

            // Re-record Button
            TextButton.icon(
              onPressed: _deleteRecording,
              icon: Icon(
                CupertinoIcons.refresh,
                size: 15.sp,
                color: ColorManager.goldLight,
              ),
              label: Text(
                'submit.recorder.re_record'.tr(),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 12.sp,
                  color: ColorManager.goldLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
