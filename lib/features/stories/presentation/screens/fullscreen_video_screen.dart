import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/helpers/app_log_store.dart';
import 'package:hekayat_3al_raf/core/media/video/cubit/video_playback_cubit.dart';
import 'package:hekayat_3al_raf/core/media/video/model/video_playback_state.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:video_player/video_player.dart';

/// [FullScreenVideoScreen] renders an isolated, standalone Fullscreen video surface
/// with auto-rotation support and safe system UI restoration.
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
  late final bool _isLandscapeVideo;
  bool _isDragging = false;
  double _dragPositionMs = 0.0;

  @override
  void initState() {
    super.initState();
    final aspect = widget.cubit.state.aspectRatio;
    final isLandscape = aspect > 1.0;

    AppLogStore.instance.log(
      '[FullScreenVideoScreen] Mounted. AspectRatio: $aspect, isLandscape: $isLandscape',
    );

    // The app stays portrait-locked at the OS level. Rotating the OS surface
    // while a video texture is attached produces a black frame on iOS, so we
    // rotate the content ourselves via RotatedBox instead (see build()).
    _isLandscapeVideo = isLandscape;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _restorePortraitAndExit() async {
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
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
    final cubit = widget.cubit;
    final controller = cubit.activeController;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _restorePortraitAndExit();
      },
      child: BlocProvider<VideoPlayerCubit>.value(
        value: cubit,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: BlocBuilder<VideoPlayerCubit, VideoPlaybackState>(
            builder: (context, state) {
              if (controller == null || !controller.value.isInitialized) {
                return const Center(
                  child: CircularProgressIndicator(color: ColorManager.gold),
                );
              }

              return RotatedBox(
                quarterTurns: _isLandscapeVideo ? 1 : 0,
                child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.center,
                children: [
                  // 1. Native Video Surface
                  Center(
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio > 0
                          ? controller.value.aspectRatio
                          : (state.aspectRatio > 0 ? state.aspectRatio : 16 / 9),
                      child: VideoPlayer(
                        controller,
                        key: ObjectKey(controller),
                      ),
                    ),
                  ),

                  // 2. Gesture Detector for toggling overlay
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: cubit.toggleControls,
                      child: Container(
                        color: state.isControlsVisible
                            ? Colors.black.withValues(alpha: 0.35)
                            : Colors.transparent,
                      ),
                    ),
                  ),

                  // 3. Fullscreen Controls Overlay
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
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 12.h,
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      CupertinoIcons.back,
                                      color: ColorManager.paper100,
                                      size: 26,
                                    ),
                                    onPressed: _restorePortraitAndExit,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      widget.title,
                                      style: AppFonts.ibmPlexSansArabic(
                                        color: ColorManager.paper100,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Center Play / Pause Button
                            Center(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: cubit.togglePlay,
                                  borderRadius: BorderRadius.circular(35.r),
                                  child: ClipOval(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        width: 68.r,
                                        height: 68.r,
                                        decoration: BoxDecoration(
                                          color: ColorManager.primaryDark.withValues(alpha: 0.7),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: ColorManager.gold.withValues(alpha: 0.8),
                                            width: 1.8,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            state.status == VideoStatus.playing
                                                ? CupertinoIcons.pause_fill
                                                : (state.status == VideoStatus.completed
                                                    ? CupertinoIcons.restart
                                                    : CupertinoIcons.play_arrow_solid),
                                            color: ColorManager.goldLight,
                                            size: 32.sp,
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
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 12.h,
                              ),
                              child: BlocBuilder<VideoPlayerCubit, VideoPlaybackState>(
                                buildWhen: (prev, curr) =>
                                    prev.position != curr.position ||
                                    prev.duration != curr.duration,
                                builder: (context, timeState) {
                                  final totalMs = timeState.duration.inMilliseconds.toDouble();
                                  final maxVal = totalMs > 0 ? totalMs : 1.0;

                                  final currentVal = _isDragging
                                      ? _dragPositionMs.clamp(0.0, maxVal)
                                      : timeState.position.inMilliseconds.toDouble().clamp(0.0, maxVal);

                                  final displayDuration = _isDragging
                                      ? Duration(milliseconds: _dragPositionMs.toInt())
                                      : timeState.position;

                                  return Row(
                                    children: [
                                      Text(
                                        _formatDuration(displayDuration),
                                        style: AppFonts.ibmPlexSansArabic(
                                          color: ColorManager.paper200,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: SliderTheme(
                                          data: SliderTheme.of(context).copyWith(
                                            trackHeight: 3.h,
                                            thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius: 6.r,
                                            ),
                                            overlayShape: RoundSliderOverlayShape(
                                              overlayRadius: 12.r,
                                            ),
                                            activeTrackColor: ColorManager.gold,
                                            inactiveTrackColor: ColorManager.paper400.withValues(alpha: 0.3),
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
                                              setState(() => _dragPositionMs = v);
                                            },
                                            onChangeEnd: (v) {
                                              setState(() => _isDragging = false);
                                              cubit.seek(Duration(milliseconds: v.toInt()));
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        _formatDuration(timeState.duration),
                                        style: AppFonts.ibmPlexSansArabic(
                                          color: ColorManager.paper400,
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                      SizedBox(width: 16.w),
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
