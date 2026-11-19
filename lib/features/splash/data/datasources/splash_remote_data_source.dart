import 'package:hekayat_3al_raf/core/network/api_endpoints.dart';
import 'package:hekayat_3al_raf/core/network/inetwork_helper.dart';
import 'package:hekayat_3al_raf/features/splash/data/models/app_config_model.dart';

abstract class ISplashRemoteDataSource {
  Future<AppConfigModel> getAppConfig();
}

class SplashRemoteDataSource implements ISplashRemoteDataSource {
  final InetworkHelper _networkHelper;

  const SplashRemoteDataSource(this._networkHelper);

  @override
  Future<AppConfigModel> getAppConfig() async {
    final response = await _networkHelper.get(ApiEndpoints.config);
    final json = response.data as Map<String, dynamic>;
    return AppConfigModel.fromJson(json);
  }
}
