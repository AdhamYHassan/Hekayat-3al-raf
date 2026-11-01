import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_details_entity.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/paginated_ambassadors_entity.dart';

abstract class IAmbassadorRemoteDataSource {
  Future<PaginatedAmbassadorsEntity> getAmbassadorsList({int limit = 10, int offset = 0});
  Future<AmbassadorDetailsEntity> getAmbassadorDetails(String ambassadorId);
  Future<AmbassadorQaItem> submitQuestion({
    required String ambassadorId,
    required String authorName,
    required String city,
    required String question,
  });
}

