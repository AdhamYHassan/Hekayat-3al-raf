import 'package:hekayat_3al_raf/core/network/inetwork_helper.dart';
import 'package:hekayat_3al_raf/features/podcast/data/datasources/i_podcast_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/podcast/data/models/paginated_podcasts_dto.dart';
import 'package:hekayat_3al_raf/features/podcast/data/models/podcast_details_dto.dart';

class PodcastRemoteDataSource implements IPodcastRemoteDataSource {
  final InetworkHelper _networkHelper;

  const PodcastRemoteDataSource(this._networkHelper);

  @override
  Future<PodcastDetailsResponseDto> getPodcastDetails(int id) async {
    final response = await _networkHelper.get('podcast/$id/');
    return PodcastDetailsResponseDto.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<PaginatedPodcastsResponseDto> getPodcastsList({
    int limit = 10,
    int offset = 0,
  }) async {
    final response = await _networkHelper.get(
      'podcast/',
      queryParameters: {
        'limit': limit,
        'offset': offset,
      },
    );
    return PaginatedPodcastsResponseDto.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
