import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/stories/data/models/paginated_stories_dto.dart';
import 'package:hekayat_3al_raf/features/stories/domain/repositories/i_story_repository.dart';

class GetStoriesListUseCase {
  final IStoryRepository _repository;

  const GetStoriesListUseCase(this._repository);

  Future<ApiResult<PaginatedStoriesEntity>> call({
    int limit = 10,
    int offset = 0,
    String? q,
    String? sort,
    String? kind,
    String? type,
  }) {
    return _repository.getStories(
      limit: limit,
      offset: offset,
      q: q,
      sort: sort,
      kind: kind,
      type: type,
    );
  }
}

