import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart'; // ضروري عشان kDebugMode
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_endpoints.dart';
import 'my_interceptor.dart';

class DioFactory {
  DioFactory._();

  static Dio? dio;
  static const String baseUrl = ApiEndpoints.baseUrl;

  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 30);

    if (dio == null) {
      dio = Dio();
      dio!
        ..options.baseUrl = baseUrl
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;

      final adapter = dio!.httpClientAdapter;
      if (adapter is IOHttpClientAdapter) {
        adapter.createHttpClient = () {
          final client = HttpClient();

          // الحل هنا: بنفعل الـ bypass ده في الـ Debug Mode بس!
          if (kDebugMode) {
            client.badCertificateCallback =
                (X509Certificate cert, String host, int port) => true;
          }

          return client;
        };
      }

      addDioHeaders();
      addDioInterceptor();
    }
    return dio!;
  }

  static void addDioHeaders() {
    dio?.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  static void addDioInterceptor() {
    dio?.interceptors.add(MyInterceptor());
    if (kDebugMode) {
      dio?.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          responseBody: true,
          responseHeader: true,
        ),
      );
    }
  }

  static void updateLanguage(String languageCode) {
    if (dio != null) {
      dio!.options.headers['lang'] = languageCode;
    }
  }
}
