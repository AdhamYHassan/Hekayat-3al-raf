import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:hekayat_3al_raf/core/helpers/secure_storage_helper.dart';

class DeviceHelper {
  DeviceHelper._();

  /// Retrieves a persistent, unique device ID.
  /// Reads from secure storage first; if absent, derives or generates a secure UUID,
  /// caches it permanently in secure storage, and returns it.
  static Future<String?> getDeviceId() async {
    String? storedId = await SecureStorageHelper.getDeviceId();
    if (storedId != null && storedId.isNotEmpty) {
      return storedId;
    }

    String? deviceId;

    try {
      if (Platform.isIOS) {
        final deviceInfo = DeviceInfoPlugin();
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      }
    } catch (_) {
      deviceId = null;
    }

    // On Android or as iOS fallback, generate a cryptographically secure UUID
    if (deviceId == null || deviceId.isEmpty) {
      deviceId = _generateSecureUuid();
    }

    await SecureStorageHelper.saveDeviceId(deviceId);

    return deviceId;
  }

  /// Generates a cryptographically secure RFC-4122 v4 UUID in pure Dart.
  static String _generateSecureUuid() {
    final random = Random.secure();
    final values = List<int>.generate(16, (_) => random.nextInt(256));
    values[6] = (values[6] & 0x0f) | 0x40; // v4 format
    values[8] = (values[8] & 0x3f) | 0x80; // variant RFC 4122
    final hex = values.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}

