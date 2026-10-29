import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_data_entity.dart';
import 'package:hekayat_3al_raf/features/home/domain/repositories/i_home_repository.dart';

/// Interactor / Use Case for fetching Home screen data.
///
/// Follows Single Responsibility Principle (SRP): has one reason to change,
/// which is the business rule for loading home feed content.
class GetHomeDataUseCase {
  final IHomeRepository _repository;

  const GetHomeDataUseCase(this._repository);

  Future<ApiResult<HomeDataEntity>> call() async {
    return await _repository.getHomeData();
  }
}

