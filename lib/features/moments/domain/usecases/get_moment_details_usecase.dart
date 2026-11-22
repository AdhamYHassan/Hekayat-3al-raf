import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/moments/domain/entities/moment_details_entity.dart';
import 'package:hekayat_3al_raf/features/moments/domain/repositories/i_moments_repository.dart';

class GetMomentDetailsUseCase {
  final IMomentsRepository _repository;

  const GetMomentDetailsUseCase(this._repository);

  Future<ApiResult<MomentDetailsEntity>> call(int id) {
    return _repository.getMomentDetails(id);
  }
}
