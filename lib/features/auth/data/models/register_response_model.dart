import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/login_response_model.dart';

class RegisterResponseModel extends Equatable {
  final bool status;
  final int statusCode;
  final String message;
  final String accessToken;
  final String refreshToken;
  final UserModel? user;

  const RegisterResponseModel({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    this.user,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    final accessToken = data['access'] as String? ??
        data['token'] as String? ??
        '';

    final refreshToken = data['refresh'] as String? ?? '';

    final userData = data['user'] as Map<String, dynamic>?;

    return RegisterResponseModel(
      status: json['status'] as bool? ?? true,
      statusCode: json['status_code'] as int? ?? 201,
      message: json['message'] as String? ?? 'حسابك اتعمل.',
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: userData != null ? UserModel.fromJson(userData) : null,
    );
  }

  @override
  List<Object?> get props => [
        status,
        statusCode,
        message,
        accessToken,
        refreshToken,
        user,
      ];
}

