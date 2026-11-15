import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';

/// Helper service for Google Play In-App Updates.
///
/// Ensures compliance with Clean Architecture by isolating external
/// Play Core platform channel calls. Safe across non-Android platforms.
class InAppUpdateHelper {
  InAppUpdateHelper._();

  /// Checks for Google Play update and triggers flexible/immediate update if available.
  static Future<void> checkForUpdate() async {
    // In-app update is strictly an Android Play Store feature
    if (kIsWeb || !Platform.isAndroid) return;

    try {
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        }
      }
    } catch (e) {
      debugPrint('[InAppUpdateHelper] Update check skipped or failed: $e');
    }
  }
}
