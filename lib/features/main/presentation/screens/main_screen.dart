import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/screens/ambassadors_screen.dart';
import 'package:hekayat_3al_raf/features/home/presentation/screens/home_feed_screen.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/screens/stories_feed_screen.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/screens/submit_story_screen.dart';
import 'package:hekayat_3al_raf/features/main/presentation/bloc/main_cubit.dart';
import 'package:hekayat_3al_raf/features/main/presentation/bloc/main_state.dart';
import 'package:hekayat_3al_raf/features/main/presentation/bloc/nav_bar_scroll_cubit.dart';
import 'package:hekayat_3al_raf/features/main/presentation/widgets/dynamic_floating_nav_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MainCubit>(create: (_) => MainCubit()),
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
                _TabPlaceholder(title: 'المزيد'),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: const DynamicFloatingNavBar(),
    );
  }
}

class _TabPlaceholder extends StatelessWidget {
  final String title;

  const _TabPlaceholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 80, bottom: 120),
      itemCount: 40,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('$title - عنصر تجريبي رقم #$index'),
          subtitle: const Text(
            'مرر الشاشة للأسفل لتجربة تصغير الـ Floating Bar',
          ),
        );
      },
    );
  }
}
