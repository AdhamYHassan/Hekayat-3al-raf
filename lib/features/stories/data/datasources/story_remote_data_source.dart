import 'package:hekayat_3al_raf/core/network/api_endpoints.dart';
import 'package:hekayat_3al_raf/core/network/inetwork_helper.dart';
import 'package:hekayat_3al_raf/features/stories/data/datasources/i_story_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/stories/data/models/paginated_stories_dto.dart';
import 'package:hekayat_3al_raf/features/stories/data/models/story_details_dto.dart';
import 'package:hekayat_3al_raf/features/stories/domain/entities/story_details_entity.dart';
import 'package:hekayat_3al_raf/features/stories/domain/entities/story_type_entity.dart';

class StoryRemoteDataSource implements IStoryRemoteDataSource {
  final InetworkHelper _networkHelper;

  const StoryRemoteDataSource(this._networkHelper);

  @override
  Future<StoryDetailsEntity> getStoryDetails(String storyId) async {
    final response = await _networkHelper.get(ApiEndpoints.storyDetails(storyId));
    final rawData = response.data as Map<String, dynamic>;

    final dto = StoryDetailsResponseDto.fromJson(rawData);
    return dto.data.toDomain();
  }

  @override
  Future<PaginatedStoriesEntity> getStories({
    int limit = 10,
    int offset = 0,
    String? q,
    String? sort,
    String? kind,
    String? type,
  }) async {
    final endpoint = ApiEndpoints.stories(
      limit: limit,
      offset: offset,
      q: q,
      sort: sort,
      kind: kind,
      type: type,
    );

    final response = await _networkHelper.get(endpoint);
    final rawData = response.data as Map<String, dynamic>;

    if (rawData['data'] is Map<String, dynamic>) {
      final dto = PaginatedStoriesDto.fromJson(rawData['data'] as Map<String, dynamic>);
      final items = dto.results.map((r) => r.toDomain()).toList();
      final hasMore = (offset + items.length) < dto.count;

      return PaginatedStoriesEntity(
        count: dto.count,
        hasMore: hasMore,
        stories: items,
      );
    }

    throw Exception('Invalid stories response structure');
  }

  @override
  Future<List<StoryTypeEntity>> getStoryTypes() async {
    final response = await _networkHelper.get(ApiEndpoints.storyTypes);
    final rawData = response.data as Map<String, dynamic>;

    if (rawData['data'] is List<dynamic>) {
      final list = (rawData['data'] as List<dynamic>)
          .map((e) => StoryTypeDto.fromJson(e as Map<String, dynamic>).toDomain())
          .toList();
      return list;
    }

    return const [];
  }
}

