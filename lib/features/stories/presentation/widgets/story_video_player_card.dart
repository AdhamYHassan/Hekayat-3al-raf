import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/media/video/cubit/video_playback_cubit.dart';
import 'package:hekayat_3al_raf/core/media/video/model/video_playback_state.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/screens/fullscreen_video_screen.dart';
import 'package:video_player/video_player.dart';

/// [StoryVideoPlayerCard] renders a high-performance video player surface
/// with custom auto-hiding controls, 60/120 FPS slider, and memory protection.
class StoryVideoPlayerCard extends StatelessWidget {
  final String videoUrl;
  final String title;

  const StoryVideoPlayerCard({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideoPlayerCubit>(
      create: (_) => getIt<VideoPlayerCubit>()..loadVideo(videoUrl),
      child: _VideoPlayerCardView(title: title),
    );
  }
}

class _VideoPlayerCardView extends StatefulWidget {
  final String title;
  const _VideoPlayerCardView({required this.title});

  @override
  State<_VideoPlayerCardView> createState() => _VideoPlayerCardViewState();
}

class _VideoPlayerCardViewState extends State<_VideoPlayerCardView> {
  bool _isDragging = false;
  double _dragPositionMs = 0.0;

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: ColorManager.primaryLight.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: ColorManager.gold.withValues(alpha: 0.2)),
        ),
        clipBehavior: Clip.antiAlias,
        child: BlocBuilder<VideoPlayerCubit, VideoPlaybackState>(
          buildWhen: (prev, curr) =>
              prev.status != curr.status ||
              prev.aspectRatio != curr.aspectRatio ||
              prev.isControlsVisible != curr.isControlsVisible,
          builder: (context, state) {
            final cubit = context.read<VideoPlayerCubit>();
            final controller = cubit.activeController;

            if (state.status == VideoStatus.error) {
              return Container(
                height: 200.h,
                alignment: Alignment.center,
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.exclamationmark_triangle,
                      color: Colors.redAccent,
                      size: 32.sp,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      state.errorMessage ?? 'تعذر تحميل الفيديو',
                      style: GoogleFonts.ibmPlexSansArabic(
                        color: ColorManager.paper200,
                        fontSize: 12.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (controller == null || !controller.value.isInitialized) {
              return Container(
                height: 200.h,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: ColorManager.gold,
                ),
              );
            }

            return GestureDetector(
              onTap: cubit.toggleControls,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Native Video Texture Surface
                  AspectRatio(
                    aspectRatio: state.aspectRatio,
                    child: VideoPlayer(controller),
                  ),

                  // 2. Auto-Hiding Controls Overlay
                  AnimatedOpacity(
                    opacity: state.isControlsVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.35),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Header: Title
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.title,
                                    style: GoogleFonts.ibmPlexSansArabic(
                                      color: ColorManager.paper100,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Center Play / Pause / Replay Button (Heritage Glassmorphic Design)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: cubit.togglePlay,
                              borderRadius: BorderRadius.circular(36.r),
                              child: ClipOval(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                  child: Container(
                                    width: 60.w,
                                    height: 60.h,
                                    decoration: BoxDecoration(
                                      color: ColorManager.primaryDark.withValues(alpha: 0.65),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: ColorManager.gold.withValues(alpha: 0.75),
                                        width: 1.6,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ColorManager.primaryDark.withValues(alpha: 0.5),
                                          blurRadius: 12,
                                          spreadRadius: 1,
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
                                        size: 28.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // Footer: Time & Smooth Slider
                          Padding(
                            padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 6.h),
                            child:
                                BlocBuilder<
                                  VideoPlayerCubit,
                                  VideoPlaybackState
                                >(
                                  buildWhen: (prev, curr) =>
                                      prev.position != curr.position ||
                                      prev.duration != curr.duration,
                                  builder: (context, timeState) {
                                    final totalMs = timeState
                                        .duration
                                        .inMilliseconds
                                        .toDouble();
                                    final maxVal = totalMs > 0 ? totalMs : 1.0;

                                    final currentVal = _isDragging
                                        ? _dragPositionMs.clamp(0.0, maxVal)
                                        : timeState.position.inMilliseconds
                                              .toDouble()
                                              .clamp(0.0, maxVal);

                                    final displayDuration = _isDragging
                                        ? Duration(
                                            milliseconds: _dragPositionMs
                                                .toInt(),
                                          )
                                        : timeState.position;

                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SliderTheme(
                                          data: SliderTheme.of(context)
                                              .copyWith(
                                                trackHeight: 2.5.h,
                                                thumbShape:
                                                    RoundSliderThumbShape(
                                                      enabledThumbRadius: 4.r,
                                                    ),
                                                overlayShape:
                                                    RoundSliderOverlayShape(
                                                      overlayRadius: 8.r,
                                                    ),
                                                activeTrackColor:
                                                    ColorManager.gold,
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
                                              setState(
                                                () => _dragPositionMs = v,
                                              );
                                            },
                                            onChangeEnd: (v) {
                                              setState(
                                                () => _isDragging = false,
                                              );
                                              cubit.seek(
                                                Duration(
                                                  milliseconds: v.toInt(),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _formatDuration(displayDuration),
                                              style:
                                                  GoogleFonts.ibmPlexSansArabic(
                                                    color:
                                                        ColorManager.paper200,
                                                    fontSize: 10.sp,
                                                  ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  _formatDuration(
                                                    timeState.duration,
                                                  ),
                                                  style:
                                                      GoogleFonts.ibmPlexSansArabic(
                                                        color:
                                                            ColorManager.paper400,
                                                        fontSize: 10.sp,
                                                      ),
                                                ),
                                                SizedBox(width: 8.w),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            FullScreenVideoScreen(
                                                          cubit: cubit,
                                                          title: widget.title,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Icon(
                                                    CupertinoIcons.fullscreen,
                                                    color: ColorManager.gold,
                                                    size: 16.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
