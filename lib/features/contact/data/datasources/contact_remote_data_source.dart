import 'package:dio/dio.dart';
import 'package:hekayat_3al_raf/core/network/api_endpoints.dart';
import 'package:hekayat_3al_raf/core/network/inetwork_helper.dart';
import 'package:hekayat_3al_raf/features/contact/data/datasources/i_contact_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/contact/data/models/contact_request_model.dart';

class ContactRemoteDataSource implements IContactRemoteDataSource {
  final InetworkHelper _networkHelper;

  const ContactRemoteDataSource(this._networkHelper);

  @override
  Future<void> submitContactMessage(ContactRequestModel request) async {
    await _networkHelper.post(
      ApiEndpoints.contact,
      data: request.toJson(),
      options: Options(
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }
}

