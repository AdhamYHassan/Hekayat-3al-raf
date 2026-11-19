import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/splash/domain/entities/app_config_entity.dart';
import 'package:hekayat_3al_raf/features/splash/domain/repositories/i_splash_repository.dart';

class GetAppConfigUseCase {
  final ISplashRepository _repository;

  const GetAppConfigUseCase(this._repository);

  Future<ApiResult<AppConfigEntity>> call() {
    return _repository.getAppConfig();
  }
}
