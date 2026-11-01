import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/ambassador_details_entity.dart';
import '../../domain/entities/paginated_ambassadors_entity.dart';
import '../models/ambassador_details_dto.dart';
import '../models/paginated_ambassadors_dto.dart';
import 'i_ambassador_remote_data_source.dart';

/// Live Dio-backed remote data source for cultural ambassadors.
class AmbassadorRemoteDataSource implements IAmbassadorRemoteDataSource {
  final Dio _dio;

  AmbassadorRemoteDataSource(this._dio);

  @override
  Future<PaginatedAmbassadorsEntity> getAmbassadorsList({
    int limit = 10,
    int offset = 0,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.ambassadors(limit: limit, offset: offset),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    final rawData = response.data;
    if (rawData is Map<String, dynamic> && rawData['data'] is Map<String, dynamic>) {
      final dto = PaginatedAmbassadorsDto.fromJson(rawData['data'] as Map<String, dynamic>);
      final items = dto.results.map((r) => r.toDomain()).toList();
      final hasMore = (offset + items.length) < dto.count;

      return PaginatedAmbassadorsEntity(
        count: dto.count,
        hasMore: hasMore,
        ambassadors: items,
      );
    }

    throw Exception('Invalid ambassadors pagination format');
  }

  @override
  Future<AmbassadorDetailsEntity> getAmbassadorDetails(String ambassadorId) async {
    final response = await _dio.get(
      ApiEndpoints.ambassadorDetails(ambassadorId),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    final rawData = response.data;
    if (rawData is Map<String, dynamic> && rawData['data'] is Map<String, dynamic>) {
      final dto = AmbassadorDetailsDto.fromJson(rawData['data'] as Map<String, dynamic>);
      return dto.toDomain();
    }

    throw Exception('Invalid ambassador details response format');
  }

  @override
  Future<AmbassadorQaItem> submitQuestion({
    required String ambassadorId,
    required String authorName,
    required String city,
    required String question,
  }) async {
    throw UnimplementedError('Question submission is coming in a future update');
  }
}

