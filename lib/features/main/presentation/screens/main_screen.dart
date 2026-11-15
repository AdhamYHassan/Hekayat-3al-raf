import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/helpers/in_app_update_helper.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/screens/ambassadors_screen.dart';
import 'package:hekayat_3al_raf/features/home/presentation/screens/home_feed_screen.dart';
import 'package:hekayat_3al_raf/features/more/presentation/screens/more_screen.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/screens/stories_feed_screen.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/screens/submit_story_screen.dart';
import 'package:hekayat_3al_raf/features/main/presentation/bloc/main_cubit.dart';
import 'package:hekayat_3al_raf/features/main/presentation/bloc/main_state.dart';
import 'package:hekayat_3al_raf/features/main/presentation/bloc/nav_bar_scroll_cubit.dart';
import 'package:hekayat_3al_raf/features/main/presentation/widgets/dynamic_floating_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // Check for in-app updates silently in the background on Android launch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      InAppUpdateHelper.checkForUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainCubit>.value(value: getIt<MainCubit>()),
        BlocProvider<NavBarScrollCubit>(create: (_) => NavBarScrollCubit()),
      ],
      child: const _MainScreenContent(),
    );
  }
}

class _MainScreenContent extends StatelessWidget {
  const _MainScreenContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody:
          true, // يتيح للمحتوى والقوائم المرور بانسيابية خلف الـ Glass Floating Bar
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis == Axis.vertical) {
            context.read<NavBarScrollCubit>().onScrollOffsetChanged(
              notification.metrics.pixels,
            );
          }
          return false;
        },
        child: BlocBuilder<MainCubit, MainState>(
          buildWhen: (prev, curr) => prev.currentTab != curr.currentTab,
          builder: (context, state) {
            return IndexedStack(
              index: state.selectedIndex,
              children: const [
                HomeFeedScreen(),
                StoriesFeedScreen(),
                AmbassadorsScreen(),
                SubmitStoryScreen(),
                MoreScreen(),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const DynamicFloatingNavBar(),
    );
  }
}
