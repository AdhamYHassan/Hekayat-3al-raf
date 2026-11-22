import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/media/audio/cubit/audio_playback_cubit.dart';
import 'package:hekayat_3al_raf/core/routing/routes.dart';
import 'package:hekayat_3al_raf/core/widgets/app_web_view_screen.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/screens/ambassador_details_screen.dart';
import 'package:hekayat_3al_raf/features/auth/presentation/screens/login_screen.dart';
import 'package:hekayat_3al_raf/features/auth/presentation/screens/register_screen.dart';
import 'package:hekayat_3al_raf/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:hekayat_3al_raf/features/contact/presentation/screens/contact_us_screen.dart';
import 'package:hekayat_3al_raf/features/home/presentation/bloc/home_cubit.dart';
import 'package:hekayat_3al_raf/features/main/presentation/screens/main_screen.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';
import 'package:hekayat_3al_raf/features/home/presentation/widgets/moment_viewer_screen.dart';
import 'package:hekayat_3al_raf/features/moments/presentation/screens/moment_details_screen.dart';
import 'package:hekayat_3al_raf/features/moments/presentation/screens/moments_screen.dart';
import 'package:hekayat_3al_raf/features/podcast/presentation/screens/podcast_details_screen.dart';
import 'package:hekayat_3al_raf/features/podcast/presentation/screens/podcasts_screen.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/profile_user_entity.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/bloc/my_messages_cubit.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/bloc/my_stories_cubit.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/screens/my_messages_screen.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/screens/my_stories_screen.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/screens/profile_screen.dart';
import 'package:hekayat_3al_raf/features/splash/presentation/splash_screen.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/screens/story_details_screen.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_entities.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/bloc/submit_story_cubit.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/screens/submit_story_form_subscreen.dart';

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
          final storyId =
              extra?['id'] as String? ?? 'c77848a2-d890-4e60-b654-d603dcae67f6';
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
          final ambassadorSlug =
              (extra?['slug'] ?? extra?['id']) as String? ?? '';
          return _buildPageWithTransition(
            context: context,
            state: state,
            child: AmbassadorDetailsScreen(ambassadorSlug: ambassadorSlug),
          );
        },
      ),
      GoRoute(
        path: Routes.submitStoryForm,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final format =
              extra?['format'] as StorySubmissionFormat? ??
              StorySubmissionFormat.written;
          final cubit = extra?['cubit'] as SubmitStoryCubit?;

          return _buildPageWithTransition(
            context: context,
            state: state,
            child: cubit != null
                ? BlocProvider<SubmitStoryCubit>.value(
                    value: cubit,
                    child: SubmitStoryFormSubscreen(format: format),
                  )
                : BlocProvider<SubmitStoryCubit>(
                    create: (context) => getIt<SubmitStoryCubit>(),
                    child: SubmitStoryFormSubscreen(format: format),
                  ),
          );
        },
      ),
      GoRoute(
        path: Routes.podcastDetails,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final podcastId = extra?['id'] as int? ?? 0;
          return _buildPageWithTransition(
            context: context,
            state: state,
            child: PodcastDetailsScreen(podcastId: podcastId),
          );
        },
      ),
      GoRoute(
        path: Routes.podcasts,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const PodcastsScreen(),
        ),
      ),
      GoRoute(
        path: Routes.momentViewer,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final moments = extra?['moments'] as List<MomentFeedItemEntity>? ?? [];
          final initialIndex = extra?['initialIndex'] as int? ?? 0;
          return _buildPageWithTransition(
            context: context,
            state: state,
            child: MomentViewerScreen(
              moments: moments,
              initialIndex: initialIndex,
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.momentDetails,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final momentId = extra?['id'] as int? ?? 0;
          return _buildPageWithTransition(
            context: context,
            state: state,
            child: MomentDetailsScreen(momentId: momentId),
          );
        },
      ),
      GoRoute(
        path: Routes.moments,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const MomentsScreen(),
        ),
      ),
      GoRoute(
        path: Routes.contactUs,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const ContactUsScreen(),
        ),
      ),
      GoRoute(
        path: Routes.webView,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final title = extra?['title'] as String? ?? 'حكايات على الرف';
          final url =
              extra?['url'] as String? ?? 'https://hekayat3alraf.com/ar/';
          return _buildPageWithTransition(
            context: context,
            state: state,
            child: AppWebViewScreen(title: title, initialUrl: url),
          );
        },
      ),
      GoRoute(
        path: Routes.profile,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: BlocProvider<ProfileCubit>(
            create: (context) => getIt<ProfileCubit>()..loadProfile(),
            child: const ProfileScreen(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.editProfile,
        pageBuilder: (context, state) {
          final user = state.extra as ProfileUserEntity;
          return _buildPageWithTransition(
            context: context,
            state: state,
            child: BlocProvider<ProfileCubit>(
              create: (context) => getIt<ProfileCubit>()..setInitialUser(user),
              child: EditProfileScreen(user: user),
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.myStories,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: BlocProvider<MyStoriesCubit>(
            create: (context) => getIt<MyStoriesCubit>()..loadMyStories(),
            child: const MyStoriesScreen(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.myMessages,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: BlocProvider<MyMessagesCubit>(
            create: (context) => getIt<MyMessagesCubit>()..loadMyMessages(),
            child: const MyMessagesScreen(),
          ),
        ),
      ),
      GoRoute(
        path: Routes.login,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: Routes.register,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        pageBuilder: (context, state) => _buildPageWithTransition(
          context: context,
          state: state,
          child: const ForgotPasswordScreen(),
        ),
      ),
    ],
  );
}
