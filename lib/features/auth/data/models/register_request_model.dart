import 'package:equatable/equatable.dart';

class RegisterRequestModel extends Equatable {
  final String name;
  final String email;
  final String? phone;
  final String? phoneRegion;
  final String password;

  const RegisterRequestModel({
    required this.name,
    required this.email,
    this.phone,
    this.phoneRegion,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name.trim(),
      'email': email.trim(),
      'password': password.trim(),
    };
    if (phone != null && phone!.trim().isNotEmpty) {
      map['phone'] = phone!.trim();
      if (phoneRegion != null && phoneRegion!.isNotEmpty) {
        map['phone_region'] = phoneRegion;
      }
    }
    return map;
  }

  @override
  List<Object?> get props => [name, email, phone, phoneRegion, password];
}

