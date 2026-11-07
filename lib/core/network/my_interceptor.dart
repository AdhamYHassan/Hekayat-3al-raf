import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hekayat_3al_raf/core/helpers/device_helper.dart';
import 'package:hekayat_3al_raf/core/helpers/digit_converter.dart';
import 'package:hekayat_3al_raf/core/helpers/secure_storage_helper.dart';
import 'package:hekayat_3al_raf/core/network/api_endpoints.dart';
import 'package:hekayat_3al_raf/core/network/dio_factory.dart';
import 'package:hekayat_3al_raf/core/network/token_refresh_manager.dart';

class MyInterceptor extends Interceptor {
  static const List<String> _excludedPaths = [
    'auth/login',
    'auth/register',
    'auth/token/refresh',
  ];

  void _log(String message, String name, {int level = 0, Object? error}) {
    if (kDebugMode) {
      developer.log(message, name: name, level: level, error: error);
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    _log(
      'REQUEST[${options.method}] => PATH: ${options.path}',
      'Network-Request',
    );

    // 1. Device ID header injection
    try {
      final String? deviceId = await DeviceHelper.getDeviceId();
      if (deviceId != null && deviceId.isNotEmpty) {
        options.headers['X-Device-Id'] = deviceId;
      }
    } catch (_) {}

    // 2. Authorization header injection
    final bool isExcluded = _excludedPaths.any((p) => options.path.contains(p));
    if (!isExcluded) {
      final String? token = await SecureStorageHelper.getAccessToken();
      if (token != null && token.trim().isNotEmpty) {
        options.headers['Authorization'] = 'Bearer ${token.trim()}';
      }
    }

    // 3. Digit normalization
    if (options.data != null && options.data is! FormData) {
      options.data = DigitConverter.convertPayloadDigits(options.data);
    }
    if (options.queryParameters.isNotEmpty) {
      final converted =
          DigitConverter.convertPayloadDigits(options.queryParameters);
      if (converted is Map) {
        options.queryParameters = Map<String, dynamic>.from(converted);
      }
    }

    _log('Headers: ${options.headers}', 'Network-Request');
    _logRequestPayload(options);
    return handler.next(options);
  }

  void _logRequestPayload(RequestOptions options) {
    if (options.data is FormData) {
      final formData = options.data as FormData;
      for (var f in formData.fields) {
        _log('Field: ${f.key} => ${f.value}', 'Network-FormData');
      }
      for (var f in formData.files) {
        _log('File: ${f.key} => ${f.value.filename}', 'Network-FormData');
      }
    } else {
      _log('Data: ${options.data}', 'Network-Request');
      _log('Query: ${options.queryParameters}', 'Network-Request');
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    String prettyData;
    try {
      if (response.data is Map || response.data is List) {
        prettyData = const JsonEncoder.withIndent('  ').convert(response.data);
      } else {
        prettyData = response.data.toString();
      }
    } catch (_) {
      prettyData = response.data.toString();
    }

    _log(
      'RESPONSE[${response.statusCode}] => DATA:\n$prettyData',
      'Network-Response',
    );
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    _log(
      'ERROR[${err.response?.statusCode}] => ${err.message}',
      'Network-Error',
      level: 1000,
      error: err,
    );

    if (err.response?.statusCode == 401) {
      final isRefresh =
          err.requestOptions.path.contains(ApiEndpoints.refreshToken);
      final isRetry = err.requestOptions.extra['isRetry'] == true;

      if (!isRefresh && !isRetry) {
        final currentToken = await SecureStorageHelper.getAccessToken();
        final reqToken = err.requestOptions.headers['Authorization']
            ?.toString()
            .replaceFirst('Bearer ', '');

        // 1. Check if token was already refreshed by concurrent request
        if (currentToken != null &&
            currentToken.isNotEmpty &&
            currentToken != reqToken) {
          _log(
            'Token was refreshed concurrently, retrying request',
            'Network-Error',
          );
          return _retryRequest(err.requestOptions, currentToken, handler, err);
        }

        // 2. Perform refresh using shared lock
        final refreshToken = await SecureStorageHelper.getRefreshToken();
        final hadAuth =
            err.requestOptions.headers.containsKey('Authorization');

        if (hadAuth && refreshToken != null && refreshToken.isNotEmpty) {
          try {
            final newAccess = await TokenRefreshManager.refresh(refreshToken);
            if (newAccess != null && newAccess.isNotEmpty) {
              return _retryRequest(err.requestOptions, newAccess, handler, err);
            }
          } catch (e) {
            _log('Failed to refresh token: $e', 'Network-Error');
          }
        }

        if (hadAuth) {
          await TokenRefreshManager.handleRefreshFailure();
        }
      }
    }

    return handler.next(err);
  }

  void _retryRequest(
    RequestOptions options,
    String token,
    ErrorInterceptorHandler handler,
    DioException originalError,
  ) async {
    options.headers['Authorization'] = 'Bearer $token';
    options.extra['isRetry'] = true;
    try {
      final retryResponse = await DioFactory.getDio().fetch(options);
      return handler.resolve(retryResponse);
    } catch (retryError) {
      return handler.next(
        retryError is DioException ? retryError : originalError,
      );
    }
  }
}
