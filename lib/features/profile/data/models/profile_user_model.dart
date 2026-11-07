import 'package:hekayat_3al_raf/features/profile/domain/entities/profile_user_entity.dart';

class ProfileUserModel extends ProfileUserEntity {
  const ProfileUserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.displayName,
    required super.phone,
    required super.bio,
    super.avatar,
    super.isBlocked,
    super.blockReason,
    super.isStaffMember,
    super.managedAmbassadors,
    super.storiesCount,
    super.dateJoined,
  });

  factory ProfileUserModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['date_joined'] != null) {
      parsedDate = DateTime.tryParse(json['date_joined'] as String);
    }

    return ProfileUserModel(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      displayName: json['display_name'] as String? ?? json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      avatar: json['avatar'] as String?,
      isBlocked: json['is_blocked'] as bool? ?? false,
      blockReason: json['block_reason'] as String? ?? '',
      isStaffMember: json['is_staff_member'] as bool? ?? false,
      managedAmbassadors: json['managed_ambassadors'] as List<dynamic>? ?? const [],
      storiesCount: json['stories_count'] as int? ?? 0,
      dateJoined: parsedDate,
    );
  }
}

