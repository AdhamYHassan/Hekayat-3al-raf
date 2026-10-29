import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/main/presentation/bloc/main_cubit.dart';
import 'package:hekayat_3al_raf/features/main/presentation/bloc/main_state.dart';
import 'package:hekayat_3al_raf/features/main/presentation/bloc/nav_bar_scroll_cubit.dart';
import 'package:hekayat_3al_raf/features/main/presentation/bloc/nav_bar_scroll_state.dart';
import 'package:hekayat_3al_raf/features/main/presentation/widgets/nav_bar_items_row.dart';

class DynamicFloatingNavBar extends StatelessWidget {
  const DynamicFloatingNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = ColorManager.isDark(context);
    final surfaceColor = isDark
        ? ColorManager.primaryDark
        : ColorManager.primary;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final borderRadius = BorderRadius.circular(24.r);

    return BlocBuilder<NavBarScrollCubit, NavBarScrollState>(
      buildWhen: (prev, curr) => prev.isScrolled != curr.isScrolled,
      builder: (context, scrollState) {
        final isScrolled = scrollState.isScrolled;
        final targetBlur = isScrolled ? 18.0 : 10.0;
        final targetAlpha = isScrolled
            ? (isDark ? 0.85 : 0.88)
            : (isDark ? 0.95 : 0.92);
        final targetBorderColor = isScrolled
            ? ColorManager.gold.withValues(alpha: 0.40)
            : ColorManager.gold.withValues(alpha: 0.25);

        return RepaintBoundary(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            margin: EdgeInsets.only(
              left: 10.w,
              right: 10.w,
              bottom: bottomInset > 0 ? bottomInset : 10.h,
            ),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isScrolled
                        ? (isDark ? 0.45 : 0.18)
                        : (isDark ? 0.30 : 0.12),
                  ),
                  blurRadius: isScrolled ? 20 : 14,
                  offset: Offset(0, isScrolled ? 6 : 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(end: targetBlur),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                builder: (context, blurSigma, child) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: blurSigma,
                      sigmaY: blurSigma,
                    ),
                    child: child,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  padding: EdgeInsets.symmetric(
                    vertical: isScrolled ? 8.h : 7.h,
                  ),
                  decoration: BoxDecoration(
                    color: surfaceColor.withValues(alpha: targetAlpha),
                    borderRadius: borderRadius,
                    border: Border.all(color: targetBorderColor, width: 1.2.w),
                  ),
                  child: BlocBuilder<MainCubit, MainState>(
                    buildWhen: (prev, curr) =>
                        prev.currentTab != curr.currentTab,
                    builder: (context, mainState) {
                      return NavBarItemsRow(
                        selectedIndex: mainState.selectedIndex,
                        isScrolled: isScrolled,
                        onTabSelected: (tab) =>
                            context.read<MainCubit>().changeTab(tab),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
