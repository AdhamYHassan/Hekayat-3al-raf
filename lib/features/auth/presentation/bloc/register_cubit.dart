import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/auth/data/models/register_request_model.dart';
import 'package:hekayat_3al_raf/features/auth/domain/usecases/register_usecase.dart';
import 'package:hekayat_3al_raf/features/auth/presentation/bloc/register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterCubit(this._registerUseCase) : super(const RegisterInitial());

  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String confirmPassword,
    required bool agreedToTerms,
  }) async {
    final trimmedName = name.trim();
    final trimmedPhone = phone.trim();
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();
    final trimmedConfirmPassword = confirmPassword.trim();

    if (trimmedName.isEmpty) {
      emit(const RegisterFailure('يرجى إدخال الاسم بالكامل'));
      return;
    }

    if (trimmedPhone.isEmpty) {
      emit(const RegisterFailure('يرجى إدخال رقم الموبايل'));
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (trimmedEmail.isEmpty || !emailRegex.hasMatch(trimmedEmail)) {
      emit(const RegisterFailure('يرجى إدخال بريد إلكتروني صحيح'));
      return;
    }

    if (trimmedPassword.isEmpty) {
      emit(const RegisterFailure('يرجى إدخال كلمة المرور'));
      return;
    }

    if (trimmedPassword.length < 6) {
      emit(const RegisterFailure('كلمة المرور يجب ألا تقل عن 6 أحرف'));
      return;
    }

    if (trimmedPassword != trimmedConfirmPassword) {
      emit(const RegisterFailure('كلمتا المرور غير متطابقتين'));
      return;
    }

    if (!agreedToTerms) {
      emit(const RegisterFailure('يجب الموافقة على الشروط والأحكام وسياسة الخصوصية'));
      return;
    }

    emit(const RegisterLoading());

    final request = RegisterRequestModel(
      name: trimmedName,
      phone: trimmedPhone,
      email: trimmedEmail,
      phoneRegion: 'EG',
      password: trimmedPassword,
    );

    final result = await _registerUseCase(request);

    switch (result) {
      case ApiSuccess(:final data):
        emit(RegisterSuccess(data));
      case ApiFailure(:final failure):
        emit(RegisterFailure(failure.message));
    }
  }
}

