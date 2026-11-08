import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/stories/data/models/paginated_stories_dto.dart';
import 'package:hekayat_3al_raf/features/stories/domain/entities/story_details_entity.dart';
import 'package:hekayat_3al_raf/features/stories/domain/entities/story_type_entity.dart';
import 'package:hekayat_3al_raf/features/stories/domain/entities/story_vote_result_entity.dart';

abstract class IStoryRepository {
  Future<ApiResult<StoryDetailsEntity>> getStoryDetails(String storyId);

  Future<ApiResult<StoryVoteResultEntity>> voteStory({
    required String storyId,
    required String value,
  });

  Future<ApiResult<PaginatedStoriesEntity>> getStories({
    int limit = 10,
    int offset = 0,
    String? q,
    String? sort,
    String? kind,
    String? type,
  });

  Future<ApiResult<List<StoryTypeEntity>>> getStoryTypes();
}

