import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_details_entity.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/repositories/i_ambassador_repository.dart';

/// Interactor UseCase executing the retrieval of cultural ambassador details.
class GetAmbassadorDetailsUseCase {
  final IAmbassadorRepository _repository;

  const GetAmbassadorDetailsUseCase(this._repository);

  Future<ApiResult<AmbassadorDetailsEntity>> call(String ambassadorId) {
    return _repository.getAmbassadorDetails(ambassadorId);
  }
}

