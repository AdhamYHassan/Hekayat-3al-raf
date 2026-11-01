import 'package:hekayat_3al_raf/core/network/failure.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/ambassadors/data/datasources/i_ambassador_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_details_entity.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_list_item_entity.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/repositories/i_ambassador_repository.dart';

/// Concrete Repository implementation bridging Data Layer to Domain Layer
/// mapping lower level exceptions into pure typed Failure abstractions.
class AmbassadorRepositoryImpl implements IAmbassadorRepository {
  final IAmbassadorRemoteDataSource _remoteDataSource;

  const AmbassadorRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<List<AmbassadorListItemEntity>>> getAmbassadorsList() async {
    try {
      final list = await _remoteDataSource.getAmbassadorsList();
      return ApiSuccess(list);
    } catch (e) {
      return ApiFailure(ServerFailure('فشل في جلب قائمة السفراء: $e'));
    }
  }

  @override
  Future<ApiResult<AmbassadorDetailsEntity>> getAmbassadorDetails(String ambassadorId) async {
    try {
      final details = await _remoteDataSource.getAmbassadorDetails(ambassadorId);
      return ApiSuccess(details);
    } catch (e) {
      return ApiFailure(ServerFailure('فشل في جلب بيانات السفير: $e'));
    }
  }

  @override
  Future<ApiResult<AmbassadorQaItem>> submitQuestion({
    required String ambassadorId,
    required String authorName,
    required String city,
    required String question,
  }) async {
    try {
      final item = await _remoteDataSource.submitQuestion(
        ambassadorId: ambassadorId,
        authorName: authorName,
        city: city,
        question: question,
      );
      return ApiSuccess(item);
    } catch (e) {
      return ApiFailure(ServerFailure('فشل في إرسال السؤال: $e'));
    }
  }
}

