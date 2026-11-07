import 'package:equatable/equatable.dart';

class ProfileUserEntity extends Equatable {
  final int id;
  final String email;
  final String name;
  final String displayName;
  final String phone;
  final String bio;
  final String? avatar;
  final bool isBlocked;
  final String blockReason;
  final bool isStaffMember;
  final List<dynamic> managedAmbassadors;
  final int storiesCount;
  final DateTime? dateJoined;

  const ProfileUserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.displayName,
    required this.phone,
    required this.bio,
    this.avatar,
    this.isBlocked = false,
    this.blockReason = '',
    this.isStaffMember = false,
    this.managedAmbassadors = const [],
    this.storiesCount = 0,
    this.dateJoined,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        displayName,
        phone,
        bio,
        avatar,
        isBlocked,
        blockReason,
        isStaffMember,
        managedAmbassadors,
        storiesCount,
        dateJoined,
      ];
}

