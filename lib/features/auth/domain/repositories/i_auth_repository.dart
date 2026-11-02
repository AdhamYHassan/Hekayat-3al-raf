import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/login_request_model.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/login_response_model.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/register_request_model.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/register_response_model.dart';

abstract class IAuthRepository {
  Future<ApiResult<LoginResponseModel>> login(LoginRequestModel request);
  Future<ApiResult<RegisterResponseModel>> register(RegisterRequestModel request);
}

