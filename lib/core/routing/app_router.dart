import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/media/audio/cubit/audio_playback_cubit.dart';
import 'package:hekayat_3al_raf/core/routing/routes.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/screens/ambassador_details_screen.dart';
import 'package:hekayat_3al_raf/features/home/presentation/bloc/home_cubit.dart';
import 'package:hekayat_3al_raf/features/main/presentation/screens/main_screen.dart';
import 'package:hekayat_3al_raf/features/splash/presentation/splash_screen.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/screens/story_details_screen.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class AppRouter {
  AppRouter._();

  static Page<dynamic> _buildPageWithTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static const String initialRoute = Routes.splash;

  static final GoRouter router = GoRouter(
    initialLocation: initialRoute,
    observers: [routeObserver],
    routes: [
      GoRoute(
        path: Routes.splash,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const SplashScreen(),
        ),
      ),
      GoRoute(
        path: Routes.home,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: BlocProvider<HomeCubit>.value(
            value: getIt<HomeCubit>(),
            child: const MainScreen(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.storyDetails,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final storyId = extra?['id'] as String? ?? 'c77848a2-d890-4e60-b654-d603dcae67f6';
          return _buildPageWithTransition(
            context: context,
            state: state,
            // Using BlocProvider.value prevents the Global AudioPlayerCubit from
            // being disposed when the user navigates back to feed screens.
            child: BlocProvider<AudioPlayerCubit>.value(
              value: getIt<AudioPlayerCubit>(),
              child: StoryDetailsScreen(storyId: storyId),
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.ambassadorDetails,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final ambassadorId = extra?['id'] as String? ?? '1';
          return _buildPageWithTransition(
            context: context,
            state: state,
            child: AmbassadorDetailsScreen(ambassadorId: ambassadorId),
          );
        },
      ),
    ],
  );
}
