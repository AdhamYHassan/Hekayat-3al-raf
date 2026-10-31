import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/media/video/cubit/video_playback_cubit.dart';
import 'package:hekayat_3al_raf/core/media/video/model/video_playback_state.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:video_player/video_player.dart';

/// [FullScreenVideoScreen] renders the active video surface across full device landscape orientation
/// with responsive controls, gesture hit-test isolation, and bulletproof orientation restoration.
class FullScreenVideoScreen extends StatefulWidget {
  final VideoPlayerCubit cubit;
  final String title;

  const FullScreenVideoScreen({
    super.key,
    required this.cubit,
    required this.title,
  });

  @override
  State<FullScreenVideoScreen> createState() => _FullScreenVideoScreenState();
}

class _FullScreenVideoScreenState extends State<FullScreenVideoScreen> {
  bool _isDragging = false;
  double _dragPositionMs = 0.0;

  @override
  void initState() {
    super.initState();
    // 1. Force Landscape & Immersive Sticky System UI
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  /// Bulletproof helper to restore portrait orientation and system UI before popping
  Future<void> _restorePortraitAndExit() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    // Safety fallback: ensure portrait restoration if dismissed via OS gestures
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _restorePortraitAndExit();
        }
      },
      child: BlocProvider<VideoPlayerCubit>.value(
        value: widget.cubit,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Directionality(
            textDirection: TextDirection.ltr, // Enforce LTR timeline for video standards
            child: BlocBuilder<VideoPlayerCubit, VideoPlaybackState>(
              builder: (context, state) {
                final cubit = widget.cubit;
                final controller = cubit.activeController;

                if (controller == null || !controller.value.isInitialized) {
                  return const Center(
                    child: CircularProgressIndicator(color: ColorManager.gold),
                  );
                }

                return Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    // 1. Video Surface (Fitted to Screen)
                    Center(
                      child: AspectRatio(
                        aspectRatio: state.aspectRatio,
                        child: VideoPlayer(controller),
                      ),
                    ),

                    // 2. Background Tap Area for toggling controls
                    Positioned.fill(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: cubit.toggleControls,
                        child: Container(
                          color: state.isControlsVisible
                              ? Colors.black.withValues(alpha: 0.4)
                              : Colors.transparent,
                        ),
                      ),
                    ),

                    // 3. Overlay Controls
                    IgnorePointer(
                      ignoring: !state.isControlsVisible,
                      child: AnimatedOpacity(
                        opacity: state.isControlsVisible ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: SafeArea(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Top Bar: Back & Title
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(CupertinoIcons.back,
                                          color: ColorManager.paper100,
                                          size: 26),
                                      onPressed: _restorePortraitAndExit,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        widget.title,
                                        style: GoogleFonts.ibmPlexSansArabic(
                                          color: ColorManager.paper100,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Center Play/Pause/Replay Button (Pure Geometric Circle)
                              Center(
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      debugPrint('[VideoPlayer] Center Play clicked');
                                      cubit.togglePlay();
                                    },
                                    borderRadius: BorderRadius.circular(35),
                                    child: ClipOval(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                        child: Container(
                                          width: 68,
                                          height: 68,
                                          decoration: BoxDecoration(
                                            color: ColorManager.primaryDark.withValues(alpha: 0.7),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: ColorManager.gold.withValues(alpha: 0.8),
                                              width: 1.8,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: ColorManager.primaryDark.withValues(alpha: 0.6),
                                                blurRadius: 16,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Icon(
                                              state.status == VideoStatus.playing
                                                  ? CupertinoIcons.pause_fill
                                                  : (state.status == VideoStatus.completed
                                                      ? CupertinoIcons.restart
                                                      : CupertinoIcons.play_arrow_solid),
                                              color: ColorManager.goldLight,
                                              size: 32,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Bottom Bar: Slider, Duration & Exit Fullscreen
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                child: BlocBuilder<VideoPlayerCubit,
                                    VideoPlaybackState>(
                                  buildWhen: (prev, curr) =>
                                      prev.position != curr.position ||
                                      prev.duration != curr.duration,
                                  builder: (context, timeState) {
                                    final totalMs = timeState
                                        .duration.inMilliseconds
                                        .toDouble();
                                    final maxVal = totalMs > 0 ? totalMs : 1.0;

                                    final currentVal = _isDragging
                                        ? _dragPositionMs.clamp(0.0, maxVal)
                                        : timeState.position.inMilliseconds
                                            .toDouble()
                                            .clamp(0.0, maxVal);

                                    final displayDuration = _isDragging
                                        ? Duration(
                                            milliseconds:
                                                _dragPositionMs.toInt())
                                        : timeState.position;

                                    return Row(
                                      children: [
                                        Text(
                                          _formatDuration(displayDuration),
                                          style: GoogleFonts.ibmPlexSansArabic(
                                              color: ColorManager.paper200,
                                              fontSize: 13),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: SliderTheme(
                                            data: SliderTheme.of(context).copyWith(
                                              trackHeight: 3,
                                              thumbShape:
                                                  const RoundSliderThumbShape(
                                                      enabledThumbRadius: 6),
                                              overlayShape:
                                                  const RoundSliderOverlayShape(
                                                      overlayRadius: 12),
                                              activeTrackColor: ColorManager.gold,
                                              inactiveTrackColor: ColorManager
                                                  .paper400
                                                  .withValues(alpha: 0.3),
                                              thumbColor: ColorManager.gold,
                                            ),
                                            child: Slider(
                                              value: currentVal,
                                              min: 0.0,
                                              max: maxVal,
                                              onChangeStart: (v) {
                                                setState(() {
                                                  _isDragging = true;
                                                  _dragPositionMs = v;
                                                });
                                              },
                                              onChanged: (v) {
                                                setState(() =>
                                                    _dragPositionMs = v);
                                              },
                                              onChangeEnd: (v) {
                                                setState(
                                                    () => _isDragging = false);
                                                cubit.seek(Duration(
                                                    milliseconds: v.toInt()));
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _formatDuration(timeState.duration),
                                          style: GoogleFonts.ibmPlexSansArabic(
                                              color: ColorManager.paper400,
                                              fontSize: 13),
                                        ),
                                        const SizedBox(width: 16),
                                        IconButton(
                                          icon: const Icon(
                                            CupertinoIcons.fullscreen_exit,
                                            color: ColorManager.gold,
                                            size: 24,
                                          ),
                                          onPressed: _restorePortraitAndExit,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
