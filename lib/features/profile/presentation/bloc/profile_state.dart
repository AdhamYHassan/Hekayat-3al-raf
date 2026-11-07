import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/profile_user_entity.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final ProfileUserEntity user;
  final bool isUpdating;
  final String? updateSuccessMessage;
  final String? updateErrorMessage;

  const ProfileLoaded({
    required this.user,
    this.isUpdating = false,
    this.updateSuccessMessage,
    this.updateErrorMessage,
  });

  ProfileLoaded copyWith({
    ProfileUserEntity? user,
    bool? isUpdating,
    String? updateSuccessMessage,
    String? updateErrorMessage,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      isUpdating: isUpdating ?? this.isUpdating,
      updateSuccessMessage: updateSuccessMessage,
      updateErrorMessage: updateErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        user,
        isUpdating,
        updateSuccessMessage,
        updateErrorMessage,
      ];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

