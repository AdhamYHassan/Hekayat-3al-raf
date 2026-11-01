import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_details_entity.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_list_item_entity.dart';

abstract class IAmbassadorRemoteDataSource {
  Future<List<AmbassadorListItemEntity>> getAmbassadorsList();
  Future<AmbassadorDetailsEntity> getAmbassadorDetails(String ambassadorId);
  Future<AmbassadorQaItem> submitQuestion({
    required String ambassadorId,
    required String authorName,
    required String city,
    required String question,
  });
}

