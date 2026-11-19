import 'package:hekayat_3al_raf/core/network/failure.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/splash/data/datasources/splash_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/splash/domain/entities/app_config_entity.dart';
import 'package:hekayat_3al_raf/features/splash/domain/repositories/i_splash_repository.dart';

class SplashRepositoryImpl implements ISplashRepository {
  final ISplashRemoteDataSource _remoteDataSource;

  const SplashRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<AppConfigEntity>> getAppConfig() async {
    try {
      final config = await _remoteDataSource.getAppConfig();
      return ApiSuccess(config);
    } catch (e) {
      return ApiFailure(ServerFailure(e.toString()));
    }
  }
}
