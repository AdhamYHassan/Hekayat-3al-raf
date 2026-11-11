import 'package:equatable/equatable.dart';

class UpdateProfileParams extends Equatable {
  final String name;
  final String phone;
  final String phoneRegion;
  final String bio;
  final String? avatar;
  final String? avatarFilePath;

  const UpdateProfileParams({
    required this.name,
    required this.phone,
    this.phoneRegion = 'EG',
    required this.bio,
    this.avatar,
    this.avatarFilePath,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'name': name,
      'phone': phone,
      'phone_region': phoneRegion,
      'bio': bio,
    };
    if (avatar != null && avatar!.isNotEmpty) {
      map['avatar'] = avatar;
    }
    return map;
  }

  @override
  List<Object?> get props => [name, phone, phoneRegion, bio, avatar, avatarFilePath];
}

