import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_details_entity.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_list_item_entity.dart';

/// Abstract repository contract for Ambassador operations following Clean Architecture & DIP.
abstract class IAmbassadorRepository {
  /// Fetches directory list of all cultural ambassadors
  Future<ApiResult<List<AmbassadorListItemEntity>>> getAmbassadorsList();

  /// Fetches complete ambassador details by unique identifier
  Future<ApiResult<AmbassadorDetailsEntity>> getAmbassadorDetails(String ambassadorId);

  /// Submits a user question to the ambassador
  Future<ApiResult<AmbassadorQaItem>> submitQuestion({
    required String ambassadorId,
    required String authorName,
    required String city,
    required String question,
  });
}

