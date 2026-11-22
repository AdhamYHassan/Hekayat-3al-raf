import 'package:hekayat_3al_raf/core/network/inetwork_helper.dart';
import 'package:hekayat_3al_raf/features/moments/data/datasources/i_moments_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/moments/data/models/moment_details_dto.dart';
import 'package:hekayat_3al_raf/features/moments/data/models/paginated_moments_dto.dart';

class MomentsRemoteDataSource implements IMomentsRemoteDataSource {
  final InetworkHelper _networkHelper;

  const MomentsRemoteDataSource(this._networkHelper);

  @override
  Future<MomentDetailsResponseDto> getMomentDetails(int id) async {
    final response = await _networkHelper.get('moments/$id/');
    return MomentDetailsResponseDto.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<PaginatedMomentsResponseDto> getMomentsList({
    int limit = 10,
    int offset = 0,
  }) async {
    final response = await _networkHelper.get(
      'moments/',
      queryParameters: {
        'limit': limit,
        'offset': offset,
      },
    );
    return PaginatedMomentsResponseDto.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
