import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/moments/domain/entities/moment_details_entity.dart';
import 'package:hekayat_3al_raf/features/moments/domain/entities/paginated_moments_entity.dart';

abstract interface class IMomentsRepository {
  Future<ApiResult<MomentDetailsEntity>> getMomentDetails(int id);
  Future<ApiResult<PaginatedMomentsEntity>> getMomentsList({
    int limit = 10,
    int offset = 0,
  });
}
