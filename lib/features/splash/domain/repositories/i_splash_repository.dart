import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/splash/domain/entities/app_config_entity.dart';

abstract class ISplashRepository {
  Future<ApiResult<AppConfigEntity>> getAppConfig();
}
