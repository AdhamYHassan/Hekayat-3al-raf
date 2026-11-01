import 'package:hekayat_3al_raf/features/stories/data/models/paginated_stories_dto.dart';
import 'package:hekayat_3al_raf/features/stories/domain/entities/story_details_entity.dart';
import 'package:hekayat_3al_raf/features/stories/domain/entities/story_type_entity.dart';

abstract class IStoryRemoteDataSource {
  Future<StoryDetailsEntity> getStoryDetails(String storyId);

  Future<PaginatedStoriesEntity> getStories({
    int limit = 10,
    int offset = 0,
    String? q,
    String? sort,
    String? kind,
    String? type,
  });

  Future<List<StoryTypeEntity>> getStoryTypes();
}

