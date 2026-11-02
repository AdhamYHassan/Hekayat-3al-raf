import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/register_response_model.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  final RegisterResponseModel response;

  const RegisterSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class RegisterFailure extends RegisterState {
  final String errorMessage;

  const RegisterFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

