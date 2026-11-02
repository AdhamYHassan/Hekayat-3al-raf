import 'package:hekayat_3al_raf/core/helpers/secure_storage_helper.dart';
import 'package:hekayat_3al_raf/core/network/network_exceptions.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/auth/data/datasources/i_auth_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/login_request_model.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/login_response_model.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/register_request_model.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/register_response_model.dart';
import 'package:hekayat_3al_raf/features/auth/domain/repositories/i_auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<LoginResponseModel>> login(LoginRequestModel request) async {
    try {
      final response = await _remoteDataSource.login(request);

      // Persist auth session in secure storage if token exists
      if (response.token.isNotEmpty) {
        await SecureStorageHelper.saveToken(response.token);
      }
      if (response.refreshToken.isNotEmpty) {
        await SecureStorageHelper.saveRefreshToken(response.refreshToken);
      }
      if (response.user != null) {
        if (response.user!.displayName != null &&
            response.user!.displayName!.isNotEmpty) {
          await SecureStorageHelper.saveUserName(response.user!.displayName!);
        } else if (response.user!.name != null) {
          await SecureStorageHelper.saveUserName(response.user!.name!);
        }
        if (response.user!.email != null) {
          await SecureStorageHelper.saveUserEmail(response.user!.email!);
        }
        if (response.user!.phone != null) {
          await SecureStorageHelper.savePhoneNumber(response.user!.phone!);
        }
        if (response.user!.role != null) {
          await SecureStorageHelper.saveUserRole(response.user!.role!);
        }
      }

      return ApiSuccess(response);
    } catch (error) {
      return ApiFailure(NetworkExceptions.getFailure(error));
    }
  }

  @override
  Future<ApiResult<RegisterResponseModel>> register(
      RegisterRequestModel request) async {
    try {
      final response = await _remoteDataSource.register(request);

      // Persist access & refresh tokens
      if (response.accessToken.isNotEmpty) {
        await SecureStorageHelper.saveToken(response.accessToken);
      }
      if (response.refreshToken.isNotEmpty) {
        await SecureStorageHelper.saveRefreshToken(response.refreshToken);
      }

      if (response.user != null) {
        if (response.user!.name != null) {
          await SecureStorageHelper.saveUserName(response.user!.name!);
        }
        if (response.user!.email != null) {
          await SecureStorageHelper.saveUserEmail(response.user!.email!);
        }
        if (response.user!.phone != null) {
          await SecureStorageHelper.savePhoneNumber(response.user!.phone!);
        }
      }

      return ApiSuccess(response);
    } catch (error) {
      return ApiFailure(NetworkExceptions.getFailure(error));
    }
  }
}

