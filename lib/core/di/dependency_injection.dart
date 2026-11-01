import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hekayat_3al_raf/core/network/dio_factory.dart';
import 'package:hekayat_3al_raf/core/network/inetwork_helper.dart';
import 'package:hekayat_3al_raf/core/network/network_helper.dart';
import 'package:hekayat_3al_raf/core/media/audio/cubit/audio_playback_cubit.dart';
import 'package:hekayat_3al_raf/core/media/audio/service/i_audio_player_service.dart';
import 'package:hekayat_3al_raf/core/media/audio/service/just_audio_player_service.dart';
import 'package:hekayat_3al_raf/core/media/video/cubit/video_playback_cubit.dart';
import 'package:hekayat_3al_raf/core/media/video/service/default_video_player_service.dart';
import 'package:hekayat_3al_raf/features/ambassadors/data/datasources/ambassador_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/ambassadors/data/datasources/i_ambassador_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/ambassadors/data/repositories/ambassador_repository_impl.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/repositories/i_ambassador_repository.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/usecases/get_ambassador_details_usecase.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/usecases/get_ambassadors_list_usecase.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/bloc/ambassador_details_cubit.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/bloc/ambassadors_list_cubit.dart';
import 'package:hekayat_3al_raf/features/submit_story/data/repositories/submit_story_repository_impl.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/repositories/i_submit_story_repository.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/bloc/submit_story_cubit.dart';
import 'package:hekayat_3al_raf/features/stories/data/datasources/i_story_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/stories/data/datasources/story_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/stories/data/repositories/story_repository_impl.dart';
import 'package:hekayat_3al_raf/features/stories/domain/repositories/i_story_repository.dart';
import 'package:hekayat_3al_raf/features/stories/domain/usecases/get_stories_list_usecase.dart';
import 'package:hekayat_3al_raf/features/stories/domain/usecases/get_story_details_usecase.dart';
import 'package:hekayat_3al_raf/features/stories/domain/usecases/get_story_types_usecase.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/bloc/stories_feed_cubit.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/bloc/story_details_cubit.dart';
import 'package:hekayat_3al_raf/features/home/data/datasources/home_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/home/data/datasources/i_home_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/home/data/repositories/home_repository_impl.dart';
import 'package:hekayat_3al_raf/features/home/domain/repositories/i_home_repository.dart';
import 'package:hekayat_3al_raf/features/home/domain/usecases/get_home_data_usecase.dart';
import 'package:hekayat_3al_raf/features/home/presentation/bloc/home_cubit.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  // ---------------------------------------------------------------------------
  // Core Network Setup
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<Dio>(() => DioFactory.getDio());
  getIt.registerLazySingleton<InetworkHelper>(
    () => NetworkHelper(getIt<Dio>()),
  );

  // ---------------------------------------------------------------------------
  // Home Feature DI Setup (Single BFF API with Isolate & In-Memory Cache)
  // Registered as LazySingleton to enable Splash Pre-fetching and persistent cache
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<IHomeRemoteDataSource>(
    () => HomeRemoteDataSource(getIt<InetworkHelper>()),
  );

  getIt.registerLazySingleton<IHomeRepository>(
    () => HomeRepositoryImpl(getIt<IHomeRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetHomeDataUseCase>(
    () => GetHomeDataUseCase(getIt<IHomeRepository>()),
  );

  getIt.registerLazySingleton<HomeCubit>(
    () => HomeCubit(getIt<GetHomeDataUseCase>()),
  );

  // ---------------------------------------------------------------------------
  // Ambassador Feature DI Setup
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<IAmbassadorRemoteDataSource>(
    () => AmbassadorRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<IAmbassadorRepository>(
    () => AmbassadorRepositoryImpl(getIt<IAmbassadorRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetAmbassadorDetailsUseCase>(
    () => GetAmbassadorDetailsUseCase(getIt<IAmbassadorRepository>()),
  );

  getIt.registerLazySingleton<GetAmbassadorsListUseCase>(
    () => GetAmbassadorsListUseCase(getIt<IAmbassadorRepository>()),
  );

  getIt.registerFactory<AmbassadorDetailsCubit>(
    () => AmbassadorDetailsCubit(
      getIt<GetAmbassadorDetailsUseCase>(),
      getIt<IAmbassadorRepository>(),
    ),
  );

  getIt.registerFactory<AmbassadorsListCubit>(
    () => AmbassadorsListCubit(getIt<GetAmbassadorsListUseCase>()),
  );

  // ---------------------------------------------------------------------------
  // Stories Feature DI Setup
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<IStoryRemoteDataSource>(
    () => StoryRemoteDataSource(getIt<InetworkHelper>()),
  );

  getIt.registerLazySingleton<IStoryRepository>(
    () => StoryRepositoryImpl(getIt<IStoryRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetStoryDetailsUseCase>(
    () => GetStoryDetailsUseCase(getIt<IStoryRepository>()),
  );

  getIt.registerLazySingleton<GetStoriesListUseCase>(
    () => GetStoriesListUseCase(getIt<IStoryRepository>()),
  );

  getIt.registerLazySingleton<GetStoryTypesUseCase>(
    () => GetStoryTypesUseCase(getIt<IStoryRepository>()),
  );

  getIt.registerFactory<StoryDetailsCubit>(
    () => StoryDetailsCubit(getIt<GetStoryDetailsUseCase>()),
  );

  getIt.registerFactory<StoriesFeedCubit>(
    () => StoriesFeedCubit(
      storiesListUseCase: getIt<GetStoriesListUseCase>(),
      storyTypesUseCase: getIt<GetStoryTypesUseCase>(),
    ),
  );

  // ---------------------------------------------------------------------------
  // Submit Story Feature DI Setup
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<ISubmitStoryRepository>(
    () => const SubmitStoryRepositoryImpl(),
  );

  getIt.registerFactory<SubmitStoryCubit>(
    () => SubmitStoryCubit(getIt<ISubmitStoryRepository>()),
  );

  // ---------------------------------------------------------------------------
  // Audio Player DI Setup (Global Smart Singleton with Auto-Release)
  // Registered as LazySingleton to maintain background playback across screens
  // while internally managing native resource release on idle timeouts.
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<IAudioPlayerService>(
    () => JustAudioPlayerService(),
  );
  getIt.registerLazySingleton<AudioPlayerCubit>(
    () => AudioPlayerCubit(getIt<IAudioPlayerService>()),
  );
  // ---------------------------------------------------------------------------
  // Video Player DI Setup (Single-Instance GPU Factory)
  // Factory ensures a fresh video surface per story without memory leaks.
  // ---------------------------------------------------------------------------
  getIt.registerFactory<DefaultVideoPlayerService>(
    () => DefaultVideoPlayerService(),
  );
  getIt.registerFactory<VideoPlayerCubit>(
    () => VideoPlayerCubit(
      getIt<DefaultVideoPlayerService>(),
      getIt<IAudioPlayerService>(),
    ),
  );
}
