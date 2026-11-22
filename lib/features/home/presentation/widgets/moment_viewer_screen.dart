import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_cached_network_image.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';

/// Fullscreen immersive story/moment viewer for photos and videos.
class MomentViewerScreen extends StatefulWidget {
  final List<MomentFeedItemEntity> moments;
  final int initialIndex;

  const MomentViewerScreen({
    super.key,
    required this.moments,
    this.initialIndex = 0,
  });

  @override
  State<MomentViewerScreen> createState() => _MomentViewerScreenState();
}

class _MomentViewerScreenState extends State<MomentViewerScreen> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // PageView of Moments
            PageView.builder(
              controller: _pageController,
              itemCount: widget.moments.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                final moment = widget.moments[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    if (moment.imageUrl != null && moment.imageUrl!.isNotEmpty)
                      InteractiveViewer(
                        minScale: 0.8,
                        maxScale: 3.5,
                        child: Center(
                          child: AppCachedNetworkImage(
                            imageUrl: moment.imageUrl!,
                            fit: BoxFit.contain,
                            memCacheWidth: 1080,
                            memCacheHeight: 1920,
                          ),
                        ),
                      )
                    else
                      const Center(
                        child: Icon(
                          CupertinoIcons.photo,
                          size: 64,
                          color: ColorManager.paper400,
                        ),
                      ),

                    // Top & Bottom gradient protection
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 100.h,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.8),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 24.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.85),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (moment.title.isNotEmpty) ...[
                              Text(
                                moment.title,
                                style: AppFonts.alexandria(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: ColorManager.paper100,
                                  height: 1.3,
                                ),
                              ),
                              SizedBox(height: 6.h),
                            ],
                            if (moment.description.isNotEmpty) ...[
                              Text(
                                moment.description,
                                style: AppFonts.ibmPlexSansArabic(
                                  fontSize: 13.sp,
                                  color: ColorManager.paper200,
                                  height: 1.5,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8.h),
                            ],
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 3.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorManager.gold.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: ColorManager.goldLight
                                          .withValues(alpha: 0.6),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Text(
                                    moment.kind == MomentKind.video
                                        ? 'moments.kind_video'.tr()
                                        : 'moments.kind_photo'.tr(),
                                    style: AppFonts.alexandria(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: ColorManager.goldLight,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                if (moment.created.isNotEmpty) ...[
                                  Icon(
                                    CupertinoIcons.time,
                                    size: 12.sp,
                                    color: ColorManager.paper400,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    moment.created.split('T').first,
                                    style: AppFonts.ibmPlexSansArabic(
                                      fontSize: 11.sp,
                                      color: ColorManager.paper400,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Top Status Bar Indicators
            Positioned(
              top: 12.h,
              left: 16.w,
              right: 16.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: List.generate(
                      widget.moments.length,
                      (i) => Expanded(
                        child: Container(
                          height: 2.5.h,
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          decoration: BoxDecoration(
                            color: i == _currentIndex
                                ? ColorManager.goldLight
                                : Colors.white24,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Text(
                          '${_currentIndex + 1} / ${widget.moments.length}',
                          style: AppFonts.alexandria(
                            fontSize: 11.sp,
                            color: ColorManager.paper200,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: const BoxDecoration(
                            color: Colors.black45,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            CupertinoIcons.xmark,
                            size: 18.sp,
                            color: ColorManager.paper100,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
