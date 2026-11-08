import 'package:equatable/equatable.dart';

class PasswordResetConfirmRequestModel extends Equatable {
  final String email;
  final String code;
  final String newPassword;

  const PasswordResetConfirmRequestModel({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'code': code,
      'new_password': newPassword,
    };
  }

  @override
  List<Object?> get props => [email, code, newPassword];
}

