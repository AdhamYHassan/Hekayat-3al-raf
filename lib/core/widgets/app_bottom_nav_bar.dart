import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:base_app/core/theming/colors_manager.dart';
import 'package:base_app/core/theming/styles.dart';

class AppBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;
  final bool isVendor;

  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
    this.isVendor = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = ColorManager.isDark(context);

    return Container(
      decoration: BoxDecoration(
        color: ColorManager.getCard(context),
        border: Border(
          top: BorderSide(color: ColorManager.getBorder(context), width: 1.w),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          child: GNav(
            rippleColor: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
            hoverColor: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.05),
            gap: 8.w,
            activeColor: ColorManager.orange,
            iconSize: 24.sp,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            duration: const Duration(milliseconds: 300),
            tabBackgroundColor: ColorManager.orange.withValues(alpha: 0.1),
            color: isDark ? Colors.white54 : Colors.black54,
            tabs: isVendor
                ? [
                    GButton(
                      icon: Icons.home_rounded,
                      text: 'tab_home'.tr(),
                      textStyle: TextStyles.font12WhiteBold.copyWith(
                        color: ColorManager.orange,
                      ),
                    ),
                    GButton(
                      icon: Icons.pending_actions_rounded,
                      text: 'pending_requests'.tr(),
                      textStyle: TextStyles.font12WhiteBold.copyWith(
                        color: ColorManager.orange,
                      ),
                    ),
                    GButton(
                      icon: Icons.more_horiz_rounded,
                      text: 'tab_more'.tr(),
                      textStyle: TextStyles.font12WhiteBold.copyWith(
                        color: ColorManager.orange,
                      ),
                    ),
                  ]
                : [
                    GButton(
                      icon: Icons.home_rounded,
                      text: 'tab_home'.tr(),
                      textStyle: TextStyles.font12WhiteBold.copyWith(
                        color: ColorManager.orange,
                      ),
                    ),
                    GButton(
                      icon: Icons.receipt_long_rounded,
                      text: 'tab_orders'.tr(),
                      textStyle: TextStyles.font12WhiteBold.copyWith(
                        color: ColorManager.orange,
                      ),
                    ),
                    GButton(
                      icon: Icons.pending_actions_rounded,
                      text: 'pending_requests'.tr(),
                      textStyle: TextStyles.font12WhiteBold.copyWith(
                        color: ColorManager.orange,
                      ),
                    ),
                    GButton(
                      icon: Icons.more_horiz_rounded,
                      text: 'tab_more'.tr(),
                      textStyle: TextStyles.font12WhiteBold.copyWith(
                        color: ColorManager.orange,
                      ),
                    ),
                  ],
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
          ),
        ),
      ),
    );
  }
}
