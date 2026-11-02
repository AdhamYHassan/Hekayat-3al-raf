import 'package:hekayat_3al_raf/core/network/network_exceptions.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/contact/data/datasources/i_contact_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/contact/data/models/contact_request_model.dart';
import 'package:hekayat_3al_raf/features/contact/domain/repositories/i_contact_repository.dart';

class ContactRepositoryImpl implements IContactRepository {
  final IContactRemoteDataSource _remoteDataSource;

  const ContactRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<void>> submitContactMessage(
      ContactRequestModel request) async {
    try {
      await _remoteDataSource.submitContactMessage(request);
      return const ApiSuccess(null);
    } catch (error) {
      return ApiFailure(NetworkExceptions.getFailure(error));
    }
  }
}
