import 'package:equatable/equatable.dart';

sealed class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object?> get props => [];
}

/// Initial state where user inputs email
class ResetPasswordInitial extends ResetPasswordState {
  const ResetPasswordInitial();
}

/// Requesting reset code from server
class ResetPasswordRequestLoading extends ResetPasswordState {
  const ResetPasswordRequestLoading();
}

/// Reset code sent successfully to email, transitions to Step 2
class ResetPasswordCodeSent extends ResetPasswordState {
  final String email;
  final String message;

  const ResetPasswordCodeSent({
    required this.email,
    required this.message,
  });

  @override
  List<Object?> get props => [email, message];
}

/// Confirming code & setting new password
class ResetPasswordConfirmLoading extends ResetPasswordState {
  final String email;

  const ResetPasswordConfirmLoading({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Password reset completed successfully
class ResetPasswordSuccess extends ResetPasswordState {
  final String message;

  const ResetPasswordSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

/// An error occurred during request or confirmation
class ResetPasswordFailure extends ResetPasswordState {
  final String errorMessage;
  final bool isConfirmStep;
  final String? email;

  const ResetPasswordFailure({
    required this.errorMessage,
    this.isConfirmStep = false,
    this.email,
  });

  @override
  List<Object?> get props => [errorMessage, isConfirmStep, email];
}

