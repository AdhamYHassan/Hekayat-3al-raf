import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hekayat_3al_raf/core/helpers/secure_storage_helper.dart';
import 'package:hekayat_3al_raf/core/network/api_endpoints.dart';
import 'package:hekayat_3al_raf/core/network/dio_factory.dart';

class TokenRefreshManager {
  TokenRefreshManager._();

  static Completer<String?>? _refreshCompleter;

  /// Refreshes the auth token with concurrency locking.
  /// If multiple requests fail with 401 simultaneously, they all wait
  /// for the same single refresh operation rather than bombarding the server.
  static Future<String?> refresh(String refreshToken) async {
    // If a refresh is already in flight, await its completion
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<String?>();

    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: DioFactory.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      // Support for both 'refresh' and 'refresh_token' payload conventions
      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: {
          'refresh': refreshToken,
          'refresh_token': refreshToken,
        },
      );

      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};

      final nestedData = data['data'] is Map<String, dynamic>
          ? data['data'] as Map<String, dynamic>
          : data;

      final newAccessToken = (nestedData['access'] ??
              nestedData['access_token'] ??
              nestedData['token'] ??
              data['access'] ??
              data['token']) as String?;

      final newRefreshToken = (nestedData['refresh'] ??
              nestedData['refresh_token'] ??
              data['refresh']) as String?;

      if (newAccessToken != null && newAccessToken.trim().isNotEmpty) {
        await SecureStorageHelper.saveToken(newAccessToken.trim());
        if (newRefreshToken != null && newRefreshToken.trim().isNotEmpty) {
          await SecureStorageHelper.saveRefreshToken(newRefreshToken.trim());
        }
        _refreshCompleter?.complete(newAccessToken.trim());
        return newAccessToken.trim();
      } else {
        _refreshCompleter?.complete(null);
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('TokenRefreshManager error: $e');
      }
      _refreshCompleter?.complete(null);
      return null;
    } finally {
      _refreshCompleter = null;
    }
  }

  /// Handles complete refresh failure by clearing stored auth credentials.
  static Future<void> handleRefreshFailure() async {
    await SecureStorageHelper.clearToken();
    await SecureStorageHelper.clearRefreshToken();
  }
}

