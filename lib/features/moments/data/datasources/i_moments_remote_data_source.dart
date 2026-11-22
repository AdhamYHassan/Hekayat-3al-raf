import 'package:hekayat_3al_raf/features/moments/data/models/moment_details_dto.dart';
import 'package:hekayat_3al_raf/features/moments/data/models/paginated_moments_dto.dart';

abstract interface class IMomentsRemoteDataSource {
  Future<MomentDetailsResponseDto> getMomentDetails(int id);
  Future<PaginatedMomentsResponseDto> getMomentsList({
    int limit = 10,
    int offset = 0,
  });
}
