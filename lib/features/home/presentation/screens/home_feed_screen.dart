import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hekayat_3al_raf/core/routing/routes.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/home/presentation/bloc/home_cubit.dart';
import 'package:hekayat_3al_raf/features/home/presentation/bloc/home_state.dart';
import 'package:hekayat_3al_raf/features/home/presentation/widgets/home_ambassadors_list.dart';
import 'package:hekayat_3al_raf/features/home/presentation/widgets/home_featured_card.dart';
import 'package:hekayat_3al_raf/features/home/presentation/widgets/home_hero_carousel.dart';
import 'package:hekayat_3al_raf/features/home/presentation/widgets/home_regions_section.dart';
import 'package:hekayat_3al_raf/features/home/presentation/widgets/home_section_header.dart';
import 'package:hekayat_3al_raf/features/home/presentation/widgets/home_share_cta_card.dart';
import 'package:hekayat_3al_raf/features/home/presentation/widgets/home_top_stories_list.dart';
import 'package:hekayat_3al_raf/features/main/presentation/bloc/main_cubit.dart';
import 'package:hekayat_3al_raf/features/main/presentation/bloc/main_state.dart';

/// Pure Presentation Screen.
/// Free of any DI / Service Locator dependencies, making it 100% testable.
class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryDark, // #220610
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return switch (state) {
            HomeInitial() || HomeLoading() => const Center(
              child: CircularProgressIndicator(color: ColorManager.gold),
            ),
            HomeError(:final message) => Center(
              child: Text(
                message,
                style: const TextStyle(color: ColorManager.paper100),
              ),
            ),
            HomeSuccess(:final homeData) => ListView(
              padding: EdgeInsets.only(bottom: 120.h),
              children: [
                HomeHeroCarousel(
                  slides: homeData.heroSlides,
                  onDiscoverTap: () =>
                      context.read<MainCubit>().changeTab(MainTab.stories),
                  onSubmitTap: () =>
                      context.read<MainCubit>().changeTab(MainTab.submit),
                ),
                SizedBox(height: 24.h),
                HomeSectionHeader(
                  kicker: 'home.featured_kicker'.tr(),
                  title: 'home.featured_title'.tr(),
                ),
                SizedBox(height: 14.h),
                HomeFeaturedCard(
                  featured: homeData.featuredStory,
                  onTap: () => context.push(Routes.storyDetails),
                ),
                SizedBox(height: 32.h),
                HomeSectionHeader(
                  kicker: 'home.top_stories_kicker'.tr(),
                  title: 'home.top_stories_title'.tr(),
                  actionLabel: 'home.all'.tr(),
                  onActionTap: () =>
                      context.read<MainCubit>().changeTab(MainTab.stories),
                ),
                SizedBox(height: 14.h),
                HomeTopStoriesList(
                  stories: homeData.topStories,
                  onStoryTap: (_) {},
                ),
                SizedBox(height: 32.h),
                HomeSectionHeader(
                  kicker: 'home.ambassadors_kicker'.tr(),
                  title: 'home.ambassadors_title'.tr(),
                  actionLabel: 'home.all'.tr(),
                  onActionTap: () =>
                      context.read<MainCubit>().changeTab(MainTab.ambassadors),
                ),
                SizedBox(height: 14.h),
                HomeAmbassadorsList(
                  ambassadors: homeData.ambassadors,
                  onAmbassadorTap: (_) {},
                ),
                SizedBox(height: 32.h),
                HomeSectionHeader(
                  kicker: 'home.regions_kicker'.tr(),
                  title: 'home.regions_title'.tr(),
                ),
                SizedBox(height: 14.h),
                HomeRegionsSection(
                  regions: homeData.regions,
                  onRegionTap: (_) {},
                ),
                SizedBox(height: 32.h),
                HomeShareCtaCard(
                  onSubmitTap: () =>
                      context.read<MainCubit>().changeTab(MainTab.submit),
                ),
              ],
            ),
          };
        },
      ),
    );
  }
}
