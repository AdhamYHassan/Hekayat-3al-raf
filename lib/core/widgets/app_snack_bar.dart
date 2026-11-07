import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';

enum AppSnackBarType {
  success,
  error,
  info,
  warning,
}

/// A luxury dark-maroon & gold styled SnackBar engineered specifically
/// for the "حكايات على الرف" design system.
///
/// Features:
/// - Floating behavior positioned safely above bottom navigation bar
/// - Translucent backdrop blur / glassmorphism finish with glowing brand border
/// - Consistent GoogleFonts typography (Alexandria / IBM Plex Sans Arabic)
/// - Custom brand icons for Success, Error, Warning, and Info
class AppSnackBar {
  AppSnackBar._();

  static void showSuccess(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      title: title,
      type: AppSnackBarType.success,
      duration: duration,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      title: title,
      type: AppSnackBarType.error,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      title: title,
      type: AppSnackBarType.info,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      message: message,
      title: title,
      type: AppSnackBarType.warning,
      duration: duration,
    );
  }

  static void show(
    BuildContext context, {
    required String message,
    String? title,
    AppSnackBarType type = AppSnackBarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger.clearSnackBars();

    // Design parameters mapped to Hekayat 3al Raf brand tokens
    final (
      Color accentColor,
      Color glowColor,
      Color iconBgColor,
      IconData iconData
    ) = switch (type) {
      AppSnackBarType.success => (
          const Color(0xFF34D399), // Emerald
          const Color(0x3334D399),
          const Color(0x1F34D399),
          CupertinoIcons.checkmark_seal_fill,
        ),
      AppSnackBarType.error => (
          const Color(0xFFF87171), // Rose / Clay
          const Color(0x33F87171),
          const Color(0x1FF87171),
          CupertinoIcons.exclamationmark_circle_fill,
        ),
      AppSnackBarType.warning => (
          ColorManager.gold,
          ColorManager.gold.withValues(alpha: 0.25),
          ColorManager.gold.withValues(alpha: 0.15),
          CupertinoIcons.exclamationmark_triangle_fill,
        ),
      AppSnackBarType.info => (
          ColorManager.goldLight,
          ColorManager.gold.withValues(alpha: 0.20),
          ColorManager.gold.withValues(alpha: 0.12),
          CupertinoIcons.info_circle_fill,
        ),
    };

    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        margin: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: 24.h,
        ),
        padding: EdgeInsets.zero,
        content: Container(
          decoration: BoxDecoration(
            color: ColorManager.primaryDark.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.35),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.55),
                blurRadius: 20.r,
                spreadRadius: 2.r,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: glowColor,
                blurRadius: 16.r,
                spreadRadius: -2.r,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Stack(
              children: [
                // Top subtle ambient glow streak
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 2.h,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accentColor.withValues(alpha: 0.0),
                          accentColor.withValues(alpha: 0.8),
                          accentColor.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 13.h,
                  ),
                  child: Row(
                    children: [
                      // Status Icon with glowing backdrop
                      Container(
                        width: 38.r,
                        height: 38.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: iconBgColor,
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            iconData,
                            color: accentColor,
                            size: 19.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Text content (Title + Message)
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (title != null && title.trim().isNotEmpty) ...[
                              Text(
                                title,
                                style: GoogleFonts.alexandria(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ColorManager.paper100,
                                ),
                              ),
                              SizedBox(height: 2.h),
                            ],
                            Text(
                              message,
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w400,
                                color: ColorManager.paper200,
                                height: 1.35,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
