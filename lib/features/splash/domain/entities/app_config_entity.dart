import 'package:equatable/equatable.dart';

class AppConfigEntity extends Equatable {
  final bool updateRequired;
  final bool updateAvailable;
  final String minVersion;
  final String latestVersion;
  final String androidUrl;
  final String iosUrl;

  const AppConfigEntity({
    required this.updateRequired,
    required this.updateAvailable,
    required this.minVersion,
    required this.latestVersion,
    required this.androidUrl,
    required this.iosUrl,
  });

  @override
  List<Object?> get props => [
        updateRequired,
        updateAvailable,
        minVersion,
        latestVersion,
        androidUrl,
        iosUrl,
      ];
}
