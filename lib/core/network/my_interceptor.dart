import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // ضروري عشان kDebugMode
import 'package:base_app/core/helpers/secure_storage_helper.dart';

class MyInterceptor extends Interceptor {
  // بنعدل الـ _log عشان يطبع في الـ Debug Mode فقط
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

    final String? token = await SecureStorageHelper.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    _log('Headers: ${options.headers}', 'Network-Request');

    if (options.data is FormData) {
      final formData = options.data as FormData;
      for (var field in formData.fields) {
        _log('Field: ${field.key} => ${field.value}', 'Network-FormData');
      }
      for (var file in formData.files) {
        _log('File: ${file.key} => ${file.value.filename}', 'Network-FormData');
      }
    } else {
      _log('Data: ${options.data}', 'Network-Request');
      _log('Query: ${options.queryParameters}', 'Network-Request');
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _log(
      'RESPONSE[${response.statusCode}] => DATA: ${response.data}',
      'Network-Response',
    );
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _log(
      'ERROR[${err.response?.statusCode}] => ${err.message}',
      'Network-Error',
      level: 1000,
      error: err,
    );
    return handler.next(err);
  }
}
