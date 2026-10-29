import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Top-level functions for direct calling (e.g., vGap(16), hGap(12))
Widget vGap(double height) => SizedBox(height: height.h);
Widget hGap(double width) => SizedBox(width: width.w);

// Helper class for spacing
class AppSpacing {
  AppSpacing._();

  static Widget vGap(double height) => SizedBox(height: height.h);
  static Widget hGap(double width) => SizedBox(width: width.w);
}

// Extension on num for ultra-clean layout spacing syntax (e.g., 16.vGap, 12.hGap)
extension SpacingExtension on num {
  Widget get vGap => SizedBox(height: h);
  Widget get hGap => SizedBox(width: w);
}
