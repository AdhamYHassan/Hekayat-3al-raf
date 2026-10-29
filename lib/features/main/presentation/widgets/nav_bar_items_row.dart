import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/main/presentation/bloc/main_state.dart';
import 'package:hekayat_3al_raf/features/main/presentation/widgets/floating_nav_bar_item.dart';

class NavBarItemsRow extends StatelessWidget {
  final int selectedIndex;
  final bool isScrolled;
  final ValueChanged<MainTab> onTabSelected;

  const NavBarItemsRow({
    super.key,
    required this.selectedIndex,
    required this.isScrolled,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = ColorManager.gold;
    final inactiveColor = ColorManager.isDark(context)
        ? Colors.white.withValues(alpha: 0.65)
        : Colors.white;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingNavBarItem(
          icon: CupertinoIcons.house_fill,
          label: 'nav.home'.tr(),
          isActive: selectedIndex == 0,
          isScrolled: isScrolled,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          onTap: () => onTabSelected(MainTab.home),
        ),
        FloatingNavBarItem(
          icon: CupertinoIcons.book_fill,
          label: 'nav.stories'.tr(),
          isActive: selectedIndex == 1,
          isScrolled: isScrolled,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          onTap: () => onTabSelected(MainTab.stories),
        ),
        FloatingNavBarItem(
          icon: CupertinoIcons.person_2_fill,
          label: 'nav.ambassadors'.tr(),
          isActive: selectedIndex == 2,
          isScrolled: isScrolled,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          onTap: () => onTabSelected(MainTab.ambassadors),
        ),
        FloatingNavBarItem(
          icon: CupertinoIcons.pencil_ellipsis_rectangle,
          label: 'nav.submit'.tr(),
          isActive: selectedIndex == 3,
          isScrolled: isScrolled,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          onTap: () => onTabSelected(MainTab.submit),
        ),
        FloatingNavBarItem(
          icon: CupertinoIcons.ellipsis,
          label: 'nav.more'.tr(),
          isActive: selectedIndex == 4,
          isScrolled: isScrolled,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          onTap: () => onTabSelected(MainTab.more),
        ),
      ],
    );
  }
}
