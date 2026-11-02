import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/contact/data/models/contact_request_model.dart';
import 'package:hekayat_3al_raf/features/contact/domain/repositories/i_contact_repository.dart';

class SubmitContactMessageUseCase {
  final IContactRepository _repository;

  const SubmitContactMessageUseCase(this._repository);

  Future<ApiResult<void>> call(ContactRequestModel request) {
    return _repository.submitContactMessage(request);
  }
}
