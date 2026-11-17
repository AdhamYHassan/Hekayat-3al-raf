import 'package:equatable/equatable.dart';

class UpdateProfileParams extends Equatable {
  final String? name;
  final String? email;
  final String? phone;
  final String? phoneRegion;
  final String? bio;
  final String? avatarFilePath;

  const UpdateProfileParams({
    this.name,
    this.email,
    this.phone,
    this.phoneRegion,
    this.bio,
    this.avatarFilePath,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (phone != null) {
      map['phone'] = phone;
      if (phoneRegion != null) map['phone_region'] = phoneRegion;
    }
    if (bio != null) map['bio'] = bio;
    return map;
  }

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    phoneRegion,
    bio,
    avatarFilePath,
  ];
}
