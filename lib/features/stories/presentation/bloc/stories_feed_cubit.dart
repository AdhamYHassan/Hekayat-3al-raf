import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/network_result.dart';
import '../../data/models/paginated_stories_dto.dart';
import '../../domain/entities/story_type_entity.dart';
import '../../domain/usecases/get_stories_list_usecase.dart';
import '../../domain/usecases/get_story_types_usecase.dart';
import 'stories_feed_state.dart';

class StoriesFeedCubit extends Cubit<StoriesFeedState> {
  final GetStoriesListUseCase _getStoriesListUseCase;
  final GetStoryTypesUseCase _getStoryTypesUseCase;
  static const int _pageSize = 10;

  StoriesFeedCubit({
    required GetStoriesListUseCase storiesListUseCase,
    required GetStoryTypesUseCase storyTypesUseCase,
  })  : _getStoriesListUseCase = storiesListUseCase,
        _getStoryTypesUseCase = storyTypesUseCase,
        super(const StoriesFeedState());

  /// Concurrent load of both stories and types using Future.wait.
  /// The loading shimmer only completes when BOTH finish!
  Future<void> loadInitialData() async {
    emit(state.copyWith(
      status: StoriesFeedStatus.loading,
      offset: 0,
      stories: [],
      hasMore: true,
      errorMessage: null,
    ));

    // Parallel concurrent execution
    final results = await Future.wait([
      _getStoriesListUseCase(
        limit: _pageSize,
        offset: 0,
        q: state.searchQuery,
        sort: state.selectedSort,
        kind: state.selectedKindSlug,
        type: state.selectedType,
      ),
      _getStoryTypesUseCase(),
    ]);

    final storiesResult = results[0] as ApiResult<PaginatedStoriesEntity>;
    final typesResult = results[1] as ApiResult<List<StoryTypeEntity>>;

    List<StoryTypeEntity> types = state.storyTypes;
    if (typesResult is ApiSuccess<List<StoryTypeEntity>>) {
      types = typesResult.data;
    }

    switch (storiesResult) {
      case ApiSuccess<PaginatedStoriesEntity>(:final data):
        emit(state.copyWith(
          status: StoriesFeedStatus.success,
          stories: data.stories,
          storyTypes: types,
          totalCount: data.count,
          hasMore: data.hasMore,
          offset: data.stories.length,
        ));
      case ApiFailure<PaginatedStoriesEntity>(:final failure):
        emit(state.copyWith(
          status: StoriesFeedStatus.failure,
          storyTypes: types,
          errorMessage: failure.message,
        ));
    }
  }

  /// Refreshes stories with new filters/search without re-fetching types
  Future<void> reloadStories() async {
    emit(state.copyWith(
      status: StoriesFeedStatus.loading,
      offset: 0,
      stories: [],
      hasMore: true,
      errorMessage: null,
    ));

    final result = await _getStoriesListUseCase(
      limit: _pageSize,
      offset: 0,
      q: state.searchQuery,
      sort: state.selectedSort,
      kind: state.selectedKindSlug,
      type: state.selectedType,
    );

    switch (result) {
      case ApiSuccess<PaginatedStoriesEntity>(:final data):
        emit(state.copyWith(
          status: StoriesFeedStatus.success,
          stories: data.stories,
          totalCount: data.count,
          hasMore: data.hasMore,
          offset: data.stories.length,
        ));
      case ApiFailure<PaginatedStoriesEntity>(:final failure):
        emit(state.copyWith(
          status: StoriesFeedStatus.failure,
          errorMessage: failure.message,
        ));
    }
  }

  /// Infinite scroll load more
  Future<void> loadMoreStories() async {
    if (state.isLoadingMore || !state.hasMore || state.status == StoriesFeedStatus.loading) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));

    final result = await _getStoriesListUseCase(
      limit: _pageSize,
      offset: state.offset,
      q: state.searchQuery,
      sort: state.selectedSort,
      kind: state.selectedKindSlug,
      type: state.selectedType,
    );

    switch (result) {
      case ApiSuccess<PaginatedStoriesEntity>(:final data):
        final combined = [...state.stories, ...data.stories];
        emit(state.copyWith(
          status: StoriesFeedStatus.success,
          stories: combined,
          totalCount: data.count,
          hasMore: data.hasMore,
          offset: state.offset + data.stories.length,
          isLoadingMore: false,
        ));
      case ApiFailure<PaginatedStoriesEntity>(:final failure):
        emit(state.copyWith(
          isLoadingMore: false,
          errorMessage: failure.message,
        ));
    }
  }

  void onSearchChanged(String query) {
    if (state.searchQuery == query) return;
    emit(state.copyWith(searchQuery: query));
    reloadStories();
  }

  void onSortChanged(String sort) {
    if (state.selectedSort == sort) return;
    emit(state.copyWith(selectedSort: sort));
    reloadStories();
  }

  void onKindChanged(String? kindSlug) {
    if (state.selectedKindSlug == kindSlug) return;
    emit(state.copyWith(selectedKindSlug: () => kindSlug));
    reloadStories();
  }

  void onTypeChanged(String? type) {
    if (state.selectedType == type) return;
    emit(state.copyWith(selectedType: () => type));
    reloadStories();
  }
}
