import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/contact/data/models/contact_request_model.dart';
import 'package:hekayat_3al_raf/features/contact/domain/usecases/submit_contact_message_usecase.dart';
import 'package:hekayat_3al_raf/features/contact/presentation/bloc/contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  final SubmitContactMessageUseCase _submitContactMessageUseCase;

  ContactUsCubit(this._submitContactMessageUseCase)
      : super(const ContactUsInitial());

  Future<void> submitMessage({
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String message,
  }) async {
    // 1. Client-side Validations
    if (name.trim().isEmpty) {
      emit(const ContactUsFailure('يرجى إدخال الاسم بالكامل'));
      return;
    }

    final trimmedEmail = email.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (trimmedEmail.isEmpty || !emailRegex.hasMatch(trimmedEmail)) {
      emit(const ContactUsFailure('يرجى إدخال بريد إلكتروني صحيح'));
      return;
    }

    if (subject.trim().isEmpty) {
      emit(const ContactUsFailure('يرجى اختيار موضوع الرسالة'));
      return;
    }

    if (message.trim().isEmpty) {
      emit(const ContactUsFailure('يرجى كتابة نص الرسالة'));
      return;
    }

    emit(const ContactUsSubmitting());

    final request = ContactRequestModel(
      name: name,
      email: trimmedEmail,
      phone: phone,
      subject: subject,
      message: message,
    );

    final result = await _submitContactMessageUseCase(request);

    switch (result) {
      case ApiSuccess():
        emit(const ContactUsSuccess());
      case ApiFailure(:final failure):
        emit(ContactUsFailure(failure.message));
    }
  }

  void resetState() {
    emit(const ContactUsInitial());
  }
}
