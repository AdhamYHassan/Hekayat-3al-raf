import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:base_app/core/theming/colors_manager.dart';

class AppLoadingIndicator extends StatefulWidget {
  final double size;
  final Color? color;
  final Color? secondaryColor;

  const AppLoadingIndicator({
    super.key,
    this.size = 40.0,
    this.color,
    this.secondaryColor,
  });

  @override
  State<AppLoadingIndicator> createState() => _AppLoadingIndicatorState();
}

class _AppLoadingIndicatorState extends State<AppLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dynamically retrieve theme colors if not explicitly provided
    final primaryColor = widget.color ?? ColorManager.orange;
    final secondaryColor = widget.secondaryColor ?? ColorManager.orange;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _SmoothLoadingPainter(
            progress: _controller.value,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
          ),
        );
      },
    );
  }
}

class _SmoothLoadingPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color secondaryColor;

  _SmoothLoadingPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Outer spinning arc (Clockwise rotation)
    final outerPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;

    final outerRotation = progress * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: maxRadius - outerPaint.strokeWidth / 2,
      ),
      outerRotation,
      1.5 * math.pi, // 270 degrees arc
      false,
      outerPaint,
    );

    // Inner spinning arc (Counter-clockwise rotation, slightly faster)
    final innerPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round;

    final innerRotation = -progress * 2 * math.pi * 1.5;
    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: maxRadius * 0.65 - innerPaint.strokeWidth / 2,
      ),
      innerRotation,
      math.pi, // 180 degrees arc
      false,
      innerPaint,
    );

    // Pulsing central dot with dynamic opacity
    final centerPaint = Paint()
      ..color = primaryColor.withValues(
        alpha:
            0.3 +
            0.7 *
                (0.5 -
                    (progress - 0.5).abs() *
                        2), // smooth pulsation between 0.3 and 1.0 opacity
      )
      ..style = PaintingStyle.fill;

    final centerRadius = maxRadius * 0.25;
    canvas.drawCircle(center, centerRadius, centerPaint);
  }

  @override
  bool shouldRepaint(covariant _SmoothLoadingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}
