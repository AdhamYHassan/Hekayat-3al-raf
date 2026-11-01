import 'package:flutter/material.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';

/// Lightweight custom Shimmer widget built strictly with native Flutter AnimationController
/// Zero external package dependencies, zero rebuild leaks, and GPU-accelerated.
class AppShimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFF330A16), // ColorManager.surfaceLight
    this.highlightColor = const Color(0x33C9A24B), // Gold highlight
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: const Alignment(-1.0, -0.3),
                end: const Alignment(1.0, 0.3),
                colors: [
                  widget.baseColor,
                  widget.highlightColor,
                  widget.baseColor,
                ],
                stops: [
                  (_controller.value - 0.3).clamp(0.0, 1.0),
                  _controller.value,
                  (_controller.value + 0.3).clamp(0.0, 1.0),
                ],
              ).createShader(bounds);
            },
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// Helper container box representing a single placeholder element in a Skeleton
class ShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final ShapeBorder? shape;

  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8.0,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: shape != null
          ? ShapeDecoration(
              color: ColorManager.primaryLight.withValues(alpha: 0.5),
              shape: shape!,
            )
          : BoxDecoration(
              color: ColorManager.primaryLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
    );
  }
}

