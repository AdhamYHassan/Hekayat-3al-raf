import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/stories/domain/entities/story_vote_result_entity.dart';
import 'package:hekayat_3al_raf/features/stories/domain/repositories/i_story_repository.dart';

/// [VoteStoryUseCase] encapsulates the voting business logic for stories.
///
/// Follows Single Responsibility Principle (SRP) and passes the [ApiResult]
/// cleanly to the presentation layer without leaking HTTP or data source specifics.
class VoteStoryUseCase {
  final IStoryRepository _storyRepository;

  const VoteStoryUseCase(this._storyRepository);

  Future<ApiResult<StoryVoteResultEntity>> call({
    required String storyId,
    required String value,
  }) async {
    return await _storyRepository.voteStory(
      storyId: storyId,
      value: value,
    );
  }
}

