import 'package:equatable/equatable.dart';

class LoginRequestModel extends Equatable {
  final String login;
  final String password;
  final String phoneRegion;

  const LoginRequestModel({
    required this.login,
    required this.password,
    this.phoneRegion = 'EG',
  });

  Map<String, dynamic> toJson() {
    return {
      'login': login.trim(),
      'password': password,
      'phone_region': phoneRegion,
    };
  }

  @override
  List<Object?> get props => [login, password, phoneRegion];
}

