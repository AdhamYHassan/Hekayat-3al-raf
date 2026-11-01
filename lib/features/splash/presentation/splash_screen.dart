import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/routing/routes.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/home/presentation/bloc/home_cubit.dart';
import 'package:hekayat_3al_raf/features/home/presentation/bloc/home_state.dart';

/// High-Performance Splash Screen with hardware-isolated pulsating progress bar.
///
/// Performance Optimizations (1M+ Scale):
/// 1. RepaintBoundary isolates the loading animation from the background and logo.
/// 2. Single ticker AnimatedBuilder targeting only the animated progress bar leaf widget.
/// 3. Memory-optimized image decoding via cacheWidth/cacheHeight.
/// 4. Proper cancellation and disposal of AnimationController to avoid memory leaks.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _progressAnim = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutCubic),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 1. Kick off Home Data Pre-fetching concurrently while splash logo animates
      final homeCubit = getIt<HomeCubit>();
      homeCubit.loadHomeData().then((_) {
        // Targeted Precaching: Precache Slide #1 image strictly in the background
        if (mounted && homeCubit.state is HomeSuccess) {
          final slides = (homeCubit.state as HomeSuccess).homeData.heroSlides;
          if (slides.isNotEmpty && slides.first.imageUrl.isNotEmpty) {
            precacheImage(NetworkImage(slides.first.imageUrl), context);
          }
        }
      });

      // 2. Perform locale check and proceed to home
      _navigateToNext();
    });
  }

  Future<void> _navigateToNext() async {
    if (!mounted) return;

    if (context.locale.languageCode != 'ar') {
      await context.setLocale(const Locale('ar'));
    }

    // 2.2 seconds display time for smooth splash intro
    await Future.delayed(const Duration(milliseconds: 2200));
    if (mounted) {
      context.go(Routes.home);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ColorManager.primaryDark, // #220610 (Deep Heritage Maroon)
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo with memory-constrained decoding
            Image.asset(
              'assets/images/applogo.png',
              width: 220.w,
              cacheWidth: (220 * 2).toInt(),
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
            ),
            SizedBox(height: 24.h),
            // High-Performance Gold Indeterminate Progress Indicator
            _SplashGoldProgressBar(progressAnim: _progressAnim),
          ],
        ),
      ),
    );
  }
}

/// Leaf widget strictly wrapped in a RepaintBoundary to prevent GPU layout repainting.
class _SplashGoldProgressBar extends StatelessWidget {
  final Animation<double> progressAnim;

  const _SplashGoldProgressBar({required this.progressAnim});

  @override
  Widget build(BuildContext context) {
    final barWidth = 140.w;
    final barHeight = 3.h;
    final borderRadius = BorderRadius.circular(2.r);

    return RepaintBoundary(
      child: Container(
        width: barWidth,
        height: barHeight,
        decoration: BoxDecoration(
          color: ColorManager.primaryLight.withValues(alpha: 0.5),
          borderRadius: borderRadius,
        ),
        clipBehavior: Clip.antiAlias,
        child: AnimatedBuilder(
          animation: progressAnim,
          builder: (context, child) {
            return FractionalTranslation(
              translation: Offset(progressAnim.value, 0.0),
              child: child,
            );
          },
          child: Container(
            width: barWidth * 0.45,
            height: barHeight,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.transparent,
                  ColorManager.gold,
                  ColorManager.goldLight,
                  ColorManager.gold,
                  Colors.transparent,
                ],
              ),
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: ColorManager.gold.withValues(alpha: 0.6),
                  blurRadius: 6,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
