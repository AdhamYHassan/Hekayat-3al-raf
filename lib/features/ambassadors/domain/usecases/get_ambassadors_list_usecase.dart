import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/paginated_ambassadors_entity.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/repositories/i_ambassador_repository.dart';

/// Interactor UseCase for retrieving the paginated list of cultural ambassadors.
class GetAmbassadorsListUseCase {
  final IAmbassadorRepository _repository;

  const GetAmbassadorsListUseCase(this._repository);

  Future<ApiResult<PaginatedAmbassadorsEntity>> call({int limit = 10, int offset = 0}) {
    return _repository.getAmbassadorsList(limit: limit, offset: offset);
  }
}

