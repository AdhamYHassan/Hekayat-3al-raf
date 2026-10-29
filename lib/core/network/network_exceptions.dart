import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'failure.dart';

class NetworkExceptions {
  // Private constructor to prevent instantiation
  NetworkExceptions._();

  /// Converts any exception to a typed Failure object
  static Failure getFailure(dynamic error) {
    final message = handleError(error);
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError) {
        return NetworkFailure(message);
      }
      if (error.error is SocketException) {
        return NetworkFailure(message);
      }
      return ServerFailure(message, statusCode: error.response?.statusCode);
    } else if (error is SocketException) {
      return NetworkFailure(message);
    }
    return UnknownFailure(message);
  }

  /// Handles all types of network exceptions and returns user-friendly error messages
  static String handleError(dynamic error) {
    String errorMessage = "unknown_error".tr();

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          errorMessage = "connection_timeout".tr();
          break;
        case DioExceptionType.sendTimeout:
          errorMessage = "send_timeout".tr();
          break;
        case DioExceptionType.receiveTimeout:
          errorMessage = "receive_timeout".tr();
          break;
        case DioExceptionType.badCertificate:
          errorMessage = "bad_certificate".tr();
          break;
        case DioExceptionType.badResponse:
          errorMessage = _handleBadResponse(
            error.response?.statusCode,
            error.response?.data,
          );
          break;
        case DioExceptionType.cancel:
          errorMessage = "request_cancelled".tr();
          break;
        case DioExceptionType.connectionError:
          errorMessage = "no_internet_connection".tr();
          break;
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            errorMessage = "no_internet_connection".tr();
          } else {
            errorMessage = "unknown_error".tr();
          }
          break;
        case DioExceptionType.transformTimeout:
          // TODO: Handle this case.
          throw UnimplementedError();
      }
    } else if (error is SocketException) {
      errorMessage = "no_internet_connection".tr();
    } else if (error is FormatException) {
      errorMessage = "bad_response_format".tr();
    } else {
      errorMessage = error.toString();
    }

    return errorMessage;
  }

  /// Handles response specific error codes
  static String _handleBadResponse(int? statusCode, dynamic responseData) {
    switch (statusCode) {
      case 400:
        return _getMessageFromResponse(responseData) ?? "bad_request".tr();
      case 401:
        return _getMessageFromResponse(responseData) ??
            "unauthorized_access".tr();
      case 403:
        return _getMessageFromResponse(responseData) ?? "forbidden_access".tr();
      case 404:
        return _getMessageFromResponse(responseData) ??
            "resource_not_found".tr();
      case 409:
        return _getMessageFromResponse(responseData) ??
            "conflict_occurred".tr();
      case 422:
        return _getMessageFromResponse(responseData) ?? "validation_error".tr();
      case 429:
        return _getMessageFromResponse(responseData) ??
            "too_many_requests".tr();
      case 500:
        return "server_error".tr();
      case 502:
        return "bad_gateway".tr();
      case 503:
        return "service_unavailable".tr();
      default:
        return _getMessageFromResponse(responseData) ??
            "something_went_wrong".tr();
    }
  }

  /// Extracts error message from response data
  static String? _getMessageFromResponse(dynamic responseData) {
    if (responseData != null && responseData is Map) {
      // Handle common API error response formats
      if (responseData.containsKey('non_field_errors')) {
        var nonFieldErrors = responseData['non_field_errors'];
        if (nonFieldErrors is List && nonFieldErrors.isNotEmpty) {
          return nonFieldErrors.first.toString();
        } else if (nonFieldErrors is String) {
          return nonFieldErrors;
        }
      }
      if (responseData.containsKey('password')) {
        var passwordError = responseData['password'];
        if (passwordError is List && passwordError.isNotEmpty) {
          return passwordError.first.toString();
        } else if (passwordError is String) {
          return passwordError;
        }
      }
      if (responseData.containsKey('detail') &&
          responseData['detail'] is String &&
          responseData['detail'].isNotEmpty) {
        return responseData['detail'];
      }
      if (responseData.containsKey('message')) {
        return responseData['message'];
      } else if (responseData.containsKey('error')) {
        if (responseData['error'] is String) {
          return responseData['error'];
        } else if (responseData['error'] is Map &&
            responseData['error'].containsKey('message')) {
          return responseData['error']['message'];
        }
      } else if (responseData.containsKey('errors')) {
        // Handle Laravel/similar validation errors format
        var errors = responseData['errors'];
        if (errors is Map && errors.isNotEmpty) {
          // Get first error message from the map
          var firstError = errors.entries.first;
          if (firstError.value is List &&
              (firstError.value as List).isNotEmpty) {
            return (firstError.value as List).first.toString();
          }
        } else if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        }
      }
      // If none of the known keys match, try to find the first error message recursively
      return _findFirstErrorMessage(responseData);
    }
    return null;
  }

  /// Recursively finds the first string error message in a nested structure
  static String? _findFirstErrorMessage(dynamic data) {
    if (data is String) return data;
    if (data is List && data.isNotEmpty) {
      for (var item in data) {
        final error = _findFirstErrorMessage(item);
        if (error != null) return error;
      }
    }
    if (data is Map && data.isNotEmpty) {
      for (var value in data.values) {
        final error = _findFirstErrorMessage(value);
        if (error != null) return error;
      }
    }
    return null;
  }
}
