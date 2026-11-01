import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_details_entity.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/paginated_ambassadors_entity.dart';

/// Abstract repository contract for Ambassador operations following Clean Architecture & DIP.
abstract class IAmbassadorRepository {
  /// Fetches directory list of all cultural ambassadors with pagination
  Future<ApiResult<PaginatedAmbassadorsEntity>> getAmbassadorsList({int limit = 10, int offset = 0});

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

