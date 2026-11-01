import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_list_item_entity.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/repositories/i_ambassador_repository.dart';

/// Interactor UseCase for retrieving the full list of cultural ambassadors.
class GetAmbassadorsListUseCase {
  final IAmbassadorRepository _repository;

  const GetAmbassadorsListUseCase(this._repository);

  Future<ApiResult<List<AmbassadorListItemEntity>>> call() {
    return _repository.getAmbassadorsList();
  }
}

