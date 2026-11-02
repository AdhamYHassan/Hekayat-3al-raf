import 'package:equatable/equatable.dart';

class RegisterRequestModel extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String phoneRegion;
  final String password;

  const RegisterRequestModel({
    required this.name,
    required this.email,
    required this.phone,
    this.phoneRegion = 'EG',
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'phone_region': phoneRegion,
      'password': password.trim(),
    };
  }

  @override
  List<Object?> get props => [name, email, phone, phoneRegion, password];
}

