import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int? id;
  final String? name;
  final String? displayName;
  final String? email;
  final String? phone;
  final String? bio;
  final String? avatar;
  final String? role;

  const UserModel({
    this.id,
    this.name,
    this.displayName,
    this.email,
    this.phone,
    this.bio,
    this.avatar,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      displayName: json['display_name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      bio: json['bio'] as String?,
      avatar: json['avatar'] as String?,
      role: json['role'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        displayName,
        email,
        phone,
        bio,
        avatar,
        role,
      ];
}

class LoginResponseModel extends Equatable {
  final String token; // access token
  final String refreshToken;
  final UserModel? user;
  final String? message;

  const LoginResponseModel({
    required this.token,
    this.refreshToken = '',
    this.user,
    this.message,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    // 1. Check if nested in 'data' object (e.g., { "status": true, "data": { "access": "...", "refresh": "...", "user": {...} } })
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final token = data['access'] as String? ??
        data['token'] as String? ??
        data['key'] as String? ??
        json['access'] as String? ??
        json['token'] as String? ??
        '';

    final refreshToken = data['refresh'] as String? ??
        data['refresh_token'] as String? ??
        json['refresh'] as String? ??
        '';

    final userData = data['user'] is Map<String, dynamic>
        ? data['user'] as Map<String, dynamic>
        : (json['user'] is Map<String, dynamic>
            ? json['user'] as Map<String, dynamic>
            : null);

    return LoginResponseModel(
      token: token,
      refreshToken: refreshToken,
      user: userData != null ? UserModel.fromJson(userData) : null,
      message: json['message'] as String? ?? json['detail'] as String?,
    );
  }

  @override
  List<Object?> get props => [token, refreshToken, user, message];
}
