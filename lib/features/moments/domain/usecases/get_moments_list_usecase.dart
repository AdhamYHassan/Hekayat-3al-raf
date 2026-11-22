import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/moments/domain/entities/paginated_moments_entity.dart';
import 'package:hekayat_3al_raf/features/moments/domain/repositories/i_moments_repository.dart';

class GetMomentsListUseCase {
  final IMomentsRepository _repository;

  const GetMomentsListUseCase(this._repository);

  Future<ApiResult<PaginatedMomentsEntity>> call({
    int limit = 10,
    int offset = 0,
  }) {
    return _repository.getMomentsList(limit: limit, offset: offset);
  }
}
