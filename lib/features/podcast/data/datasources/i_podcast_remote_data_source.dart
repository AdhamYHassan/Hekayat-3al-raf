import 'package:hekayat_3al_raf/features/podcast/data/models/paginated_podcasts_dto.dart';
import 'package:hekayat_3al_raf/features/podcast/data/models/podcast_details_dto.dart';

abstract interface class IPodcastRemoteDataSource {
  Future<PodcastDetailsResponseDto> getPodcastDetails(int id);
  Future<PaginatedPodcastsResponseDto> getPodcastsList({
    int limit = 10,
    int offset = 0,
  });
}
