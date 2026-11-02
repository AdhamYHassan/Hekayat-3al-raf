import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/login_request_model.dart';
import 'package:hekayat_3al_raf/features/auth/domain/usecases/login_usecase.dart';
import 'package:hekayat_3al_raf/features/auth/presentation/bloc/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit(this._loginUseCase) : super(const LoginInitial());

  Future<void> login({
    required String loginInput,
    required String password,
  }) async {
    final trimmedLogin = loginInput.trim();
    final trimmedPassword = password.trim();

    if (trimmedLogin.isEmpty) {
      emit(const LoginFailure('يرجى إدخال رقم الموبايل أو البريد الإلكتروني'));
      return;
    }

    if (trimmedPassword.isEmpty) {
      emit(const LoginFailure('يرجى إدخال كلمة المرور'));
      return;
    }

    emit(const LoginLoading());

    final request = LoginRequestModel(
      login: trimmedLogin,
      password: trimmedPassword,
      phoneRegion: 'EG',
    );

    final result = await _loginUseCase(request);

    switch (result) {
      case ApiSuccess(:final data):
        emit(LoginSuccess(data));
      case ApiFailure(:final failure):
        emit(LoginFailure(failure.message));
    }
  }
}

