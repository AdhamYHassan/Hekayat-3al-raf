import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/media/audio/cubit/audio_playback_cubit.dart';
import 'package:hekayat_3al_raf/core/media/audio/model/audio_playback_state.dart';
import 'package:hekayat_3al_raf/core/media/audio/model/audio_track.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/widgets/story_media_hero.dart';

class StoryPlayerCard extends StatefulWidget {
  final StoryMediaType mediaType;
  final String title;
  final String audioUrl;
  final String? narrator;
  final String? category;
  final String? artworkUrl;

  const StoryPlayerCard({
    super.key,
    required this.mediaType,
    required this.title,
    required this.audioUrl,
    this.narrator,
    this.category,
    this.artworkUrl,
  });

  @override
  State<StoryPlayerCard> createState() => _StoryPlayerCardState();
}

class _StoryPlayerCardState extends State<StoryPlayerCard> {
  // Local UI drag state to eliminate "Tug-of-War" seeking jitter
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
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: ColorManager.primaryLight.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: ColorManager.gold.withValues(alpha: 0.15)),
        ),
        child: BlocBuilder<AudioPlayerCubit, AudioPlaybackState>(
          builder: (context, state) {
            final isPlaying = state.status == AudioStatus.playing;
            final isLoading = state.status == AudioStatus.loading;

            // Total file duration
            final totalDurationMs = state.duration.inMilliseconds.toDouble();
            final maxSliderValue = totalDurationMs > 0 ? totalDurationMs : 1.0;

            // When dragging, bind slider directly to touch gesture; otherwise sync with player stream
            final currentSliderValue = _isDragging
                ? _dragPositionMs.clamp(0.0, maxSliderValue)
                : state.position.inMilliseconds.toDouble().clamp(
                    0.0,
                    maxSliderValue,
                  );

            final displayDuration = _isDragging
                ? Duration(milliseconds: _dragPositionMs.toInt())
                : state.position;

            return Column(
              children: [
                Row(
                  children: [
                    // زر التشغيل / الإيقاف
                    InkWell(
                      onTap: () {
                        debugPrint(
                          '[UI] Play button clicked for: ${widget.title}',
                        );
                        final track = AudioTrack(
                          id: widget.audioUrl,
                          url: widget.audioUrl,
                          title: widget.title,
                          narrator: widget.narrator ?? 'حكايات على الرف',
                          category: widget.category ?? 'تراث وذكريات',
                          artworkUrl: widget.artworkUrl,
                        );
                        context.read<AudioPlayerCubit>().playOrToggleTrack(
                          track,
                        );
                      },
                      borderRadius: BorderRadius.circular(24.r),
                      child: Container(
                        width: 48.w,
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: ColorManager.gold.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ColorManager.gold.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Center(
                          child: isLoading
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: ColorManager.gold,
                                  ),
                                )
                              : Icon(
                                  isPlaying
                                      ? CupertinoIcons.pause_fill
                                      : CupertinoIcons.play_arrow_solid,
                                  size: 20.sp,
                                  color: ColorManager.gold,
                                ),
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    // شريط التمرير والعنوان
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorManager.paper100,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          // Slider فائق النعومة (60/120 FPS UX)
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 3.h,
                              thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 5.r,
                              ),
                              overlayShape: RoundSliderOverlayShape(
                                overlayRadius: 10.r,
                              ),
                              activeTrackColor: ColorManager.gold,
                              inactiveTrackColor: ColorManager.paper400
                                  .withValues(alpha: 0.2),
                              thumbColor: ColorManager.gold,
                            ),
                            child: Slider(
                              value: currentSliderValue,
                              min: 0.0,
                              max: maxSliderValue,
                              onChangeStart: (value) {
                                setState(() {
                                  _isDragging = true;
                                  _dragPositionMs = value;
                                });
                              },
                              onChanged: (value) {
                                setState(() {
                                  _dragPositionMs = value;
                                });
                              },
                              onChangeEnd: (value) {
                                setState(() {
                                  _isDragging = false;
                                });
                                context.read<AudioPlayerCubit>().seek(
                                  Duration(milliseconds: value.toInt()),
                                );
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDuration(displayDuration),
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 10.sp,
                                  color: ColorManager.paper400,
                                ),
                              ),
                              Text(
                                _formatDuration(state.duration),
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 10.sp,
                                  color: ColorManager.paper400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  isPlaying
                      ? 'جاري الاستماع الآن'
                      : (isLoading ? 'جاري التحميل...' : 'اضغط للاستماع'),
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 10.sp,
                    color: ColorManager.paper400.withValues(alpha: 0.6),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
