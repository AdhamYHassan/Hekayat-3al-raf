import 'package:hekayat_3al_raf/features/contact/data/models/contact_request_model.dart';

abstract class IContactRemoteDataSource {
  Future<void> submitContactMessage(ContactRequestModel request);
}

