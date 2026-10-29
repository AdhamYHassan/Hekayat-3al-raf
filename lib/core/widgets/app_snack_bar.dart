import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_app/core/theming/colors_manager.dart';

class AppSnackBar {
  /// Displays a custom success SnackBar.
  static void showSuccess(BuildContext context, {required String message}) {
    _show(context, message: message, isError: false);
  }

  /// Displays a custom error SnackBar.
  static void showError(BuildContext context, {required String message}) {
    _show(context, message: message, isError: true);
  }

  static void _show(
    BuildContext context, {
    required String message,
    required bool isError,
  }) {
    final bool isDark = ColorManager.isDark(context);

    // Sleek, harmonious colors that fit light and dark modes
    final Color backgroundColor = isDark ? ColorManager.cardDark : Colors.white;
    final Color textColor = isDark ? Colors.white : ColorManager.textLight;

    // Emerald green for success, Crimson red for error
    final Color iconColor = isError
        ? (isDark ? const Color(0xFFFF6B6B) : const Color(0xFFE53E3E))
        : (isDark ? const Color(0xFF2ECC71) : const Color(0xFF27AE60));

    final Color borderColor = isError
        ? (isDark ? const Color(0x3DFF6B6B) : const Color(0x1AE53E3E))
        : (isDark ? const Color(0x3D2ECC71) : const Color(0x1A27AE60));

    final IconData icon = isError
        ? Icons.error_outline_rounded
        : Icons.check_circle_outline_rounded;

    // Clear any active SnackBars to prevent queuing delay
    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Bottom snackbar
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        // Top snackbar
        // margin: EdgeInsets.only(
        //   bottom: MediaQuery.sizeOf(context).height - 140.h,
        //   left: 16.w,
        //   right: 16.w,
        // ),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: borderColor, width: 1.5.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                blurRadius: 10.r,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 24.w),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14.sp,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
