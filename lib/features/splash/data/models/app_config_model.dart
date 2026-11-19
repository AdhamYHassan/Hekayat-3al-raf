import 'package:hekayat_3al_raf/features/splash/domain/entities/app_config_entity.dart';

class AppConfigModel extends AppConfigEntity {
  const AppConfigModel({
    required super.updateRequired,
    required super.updateAvailable,
    required super.minVersion,
    required super.latestVersion,
    required super.androidUrl,
    required super.iosUrl,
  });

  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final app = data['app'] as Map<String, dynamic>? ?? {};

    return AppConfigModel(
      updateRequired: app['update_required'] as bool? ?? false,
      updateAvailable: app['update_available'] as bool? ?? false,
      minVersion: app['min_version'] as String? ?? '1.0.0',
      latestVersion: app['latest_version'] as String? ?? '1.0.0',
      androidUrl: app['android_url'] as String? ?? '',
      iosUrl: app['ios_url'] as String? ?? '',
    );
  }
}
