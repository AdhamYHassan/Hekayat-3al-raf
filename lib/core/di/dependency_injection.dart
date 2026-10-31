import 'package:get_it/get_it.dart';
import 'package:hekayat_3al_raf/core/media/audio/cubit/audio_playback_cubit.dart';
import 'package:hekayat_3al_raf/core/media/audio/service/i_audio_player_service.dart';
import 'package:hekayat_3al_raf/core/media/audio/service/just_audio_player_service.dart';
import 'package:hekayat_3al_raf/core/media/video/cubit/video_playback_cubit.dart';
import 'package:hekayat_3al_raf/core/media/video/service/default_video_player_service.dart';
import 'package:hekayat_3al_raf/features/home/data/datasources/home_mock_data_source.dart';
import 'package:hekayat_3al_raf/features/home/data/datasources/i_home_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/home/data/repositories/home_repository_impl.dart';
import 'package:hekayat_3al_raf/features/home/domain/repositories/i_home_repository.dart';
import 'package:hekayat_3al_raf/features/home/domain/usecases/get_home_data_usecase.dart';
import 'package:hekayat_3al_raf/features/home/presentation/bloc/home_cubit.dart';

final getIt = GetIt.instance;

void setupDependencyInjection() {
  // ---------------------------------------------------------------------------
  // Home Feature DI Setup
  // ---------------------------------------------------------------------------
  getIt.registerLazySingleton<IHomeRemoteDataSource>(
    () => HomeMockDataSource(),
  );

  getIt.registerLazySingleton<IHomeRepository>(
    () => HomeRepositoryImpl(getIt<IHomeRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetHomeDataUseCase>(
    () => GetHomeDataUseCase(getIt<IHomeRepository>()),
  );

  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(getIt<GetHomeDataUseCase>()),
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
