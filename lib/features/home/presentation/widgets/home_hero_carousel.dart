import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_hero_slide.dart';

class HomeHeroCarousel extends StatefulWidget {
  final List<HomeHeroSlide> slides;
  final VoidCallback onDiscoverTap;
  final VoidCallback onSubmitTap;

  const HomeHeroCarousel({
    super.key,
    required this.slides,
    required this.onDiscoverTap,
    required this.onSubmitTap,
  });

  @override
  State<HomeHeroCarousel> createState() => _HomeHeroCarouselState();
}

class _HomeHeroCarouselState extends State<HomeHeroCarousel> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.slides.isEmpty) return const SizedBox.shrink();

    return RepaintBoundary(
      child: SizedBox(
        height: 640.h,
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: widget.slides.length,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                final slide = widget.slides[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      slide.imageUrl,
                      fit: BoxFit.cover,
                      alignment: const Alignment(0.0, -0.2),
                      cacheWidth: (375 * 2),
                      errorBuilder: (context, error, stackTrace) => Container(color: ColorManager.primaryDark),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x33220610),
                            Color(0x80220610),
                            Color(0xFF220610),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 80.h,
                      left: 20.w,
                      right: 20.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(width: 24.w, height: 1.2.h, color: ColorManager.gold),
                              SizedBox(width: 8.w),
                              Text(
                                slide.subtitle,
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: ColorManager.gold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            slide.title,
                            style: GoogleFonts.alexandria(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorManager.paper100,
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            slide.description,
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 14.sp,
                              color: ColorManager.paper200.withValues(alpha: 0.8),
                              height: 1.6,
                            ),
                            maxLines: 3,
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              InkWell(
                                onTap: widget.onDiscoverTap,
                                borderRadius: BorderRadius.circular(24.r),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    color: ColorManager.gold,
                                    borderRadius: BorderRadius.circular(24.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        slide.ctaLabel,
                                        style: GoogleFonts.ibmPlexSansArabic(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                          color: ColorManager.primaryDark,
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      Icon(CupertinoIcons.arrow_left, size: 14.sp, color: ColorManager.primaryDark),
                                    ],
                                  ),
                                ),
                              ),
                              if (slide.secondaryCtaLabel != null) ...[
                                SizedBox(width: 12.w),
                                InkWell(
                                  onTap: widget.onSubmitTap,
                                  borderRadius: BorderRadius.circular(24.r),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(24.r),
                                      border: Border.all(
                                        color: ColorManager.paper100.withValues(alpha: 0.4),
                                      ),
                                    ),
                                    child: Text(
                                      slide.secondaryCtaLabel!,
                                      style: GoogleFonts.ibmPlexSansArabic(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: ColorManager.paper100,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            // Header Logo
            Positioned(
              top: 50.h,
              left: 0,
              right: 0,
              child: Center(
                child: Image.network(
                  'https://hekayat-ala-el-raff-m9tr.bolt.host/brand/logo-gold.webp',
                  height: 38.h,
                  errorBuilder: (context, error, stackTrace) => Text(
                    'حكايات على الرف',
                    style: GoogleFonts.arefRuqaa(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorManager.gold,
                    ),
                  ),
                ),
              ),
            ),
            // Dots Indicators
            Positioned(
              bottom: 40.h,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.slides.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    width: _currentIndex == index ? 24.w : 6.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: _currentIndex == index
                          ? ColorManager.gold
                          : ColorManager.paper100.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
