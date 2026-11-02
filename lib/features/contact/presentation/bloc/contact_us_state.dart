import 'package:equatable/equatable.dart';

sealed class ContactUsState extends Equatable {
  const ContactUsState();

  @override
  List<Object?> get props => [];
}

class ContactUsInitial extends ContactUsState {
  const ContactUsInitial();
}

class ContactUsSubmitting extends ContactUsState {
  const ContactUsSubmitting();
}

class ContactUsSuccess extends ContactUsState {
  final String message;

  const ContactUsSuccess({this.message = 'تم إرسال رسالتك بنجاح، شكراً لتواصلك معنا.'});

  @override
  List<Object?> get props => [message];
}

class ContactUsFailure extends ContactUsState {
  final String errorMessage;

  const ContactUsFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

