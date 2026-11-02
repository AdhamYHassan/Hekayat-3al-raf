import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/login_response_model.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final LoginResponseModel response;

  const LoginSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class LoginFailure extends LoginState {
  final String errorMessage;

  const LoginFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

