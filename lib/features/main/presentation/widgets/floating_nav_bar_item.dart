import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FloatingNavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isScrolled;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const FloatingNavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isScrolled,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w), // يمنع التصاق النصوص المتجاورة نهائياً
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20.sp,
                color: isActive ? activeColor : inactiveColor,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: isScrolled ? 0 : null,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    opacity: isScrolled ? 0.0 : 1.0,
                    child: Padding(
                      padding: EdgeInsets.only(top: 2.h),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          label,
                          maxLines: 1,
                          softWrap: false,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.alexandria(
                            fontSize: 9.5.sp,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isActive ? activeColor : inactiveColor,
                          ),
                        ),
                      ),
                    ),
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
