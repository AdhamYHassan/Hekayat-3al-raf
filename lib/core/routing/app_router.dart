import 'package:base_app/features/home/presentation/pages/home_screen.dart';
import 'package:base_app/features/splash/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:base_app/core/routing/routes.dart';

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
          child: const HomeScreen(),
        ),
      ),
    ],
  );
}
