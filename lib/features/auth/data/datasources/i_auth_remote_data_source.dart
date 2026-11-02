import 'package:hekayat_3al_raf/features/auth/data/models/login_request_model.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/login_response_model.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/register_request_model.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/register_response_model.dart';

abstract class IAuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<RegisterResponseModel> register(RegisterRequestModel request);
}

