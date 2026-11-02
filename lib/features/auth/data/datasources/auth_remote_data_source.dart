import 'package:dio/dio.dart';
import 'package:hekayat_3al_raf/core/network/api_endpoints.dart';
import 'package:hekayat_3al_raf/core/network/inetwork_helper.dart';
import 'package:hekayat_3al_raf/features/auth/data/datasources/i_auth_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/login_request_model.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/login_response_model.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/register_request_model.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/register_response_model.dart';

class AuthRemoteDataSource implements IAuthRemoteDataSource {
  final InetworkHelper _networkHelper;

  const AuthRemoteDataSource(this._networkHelper);

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await _networkHelper.post(
      ApiEndpoints.login,
      data: request.toJson(),
      options: Options(
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    final data = response.data as Map<String, dynamic>;
    return LoginResponseModel.fromJson(data);
  }

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    final response = await _networkHelper.post(
      ApiEndpoints.register,
      data: request.toJson(),
      options: Options(
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    final data = response.data as Map<String, dynamic>;
    return RegisterResponseModel.fromJson(data);
  }
}

