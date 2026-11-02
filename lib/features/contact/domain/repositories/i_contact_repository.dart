import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/contact/data/models/contact_request_model.dart';

abstract class IContactRepository {
  Future<ApiResult<void>> submitContactMessage(ContactRequestModel request);
}
