import 'package:equatable/equatable.dart';
import '../../data/models/paginated_stories_dto.dart';
import '../../domain/entities/story_type_entity.dart';

enum StoriesFeedStatus { initial, loading, success, failure }

/// State governing the stories directory feed with pagination & multi-filtering
class StoriesFeedState extends Equatable {
  final StoriesFeedStatus status;
  final List<StoryListItemEntity> stories;
  final List<StoryTypeEntity> storyTypes;
  final int totalCount;
  final int offset;
  final bool hasMore;
  final bool isLoadingMore;

  // Active Filter Criteria
  final String searchQuery;
  final String selectedSort; // 'latest' | 'top' | 'liked' | 'viewed'
  final String? selectedKindSlug; // null means 'الكل'
  final String? selectedType; // 'audio' | 'text' | 'document' | 'video' | null

  final String? errorMessage;

  const StoriesFeedState({
    this.status = StoriesFeedStatus.initial,
    this.stories = const [],
    this.storyTypes = const [],
    this.totalCount = 0,
    this.offset = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.searchQuery = '',
    this.selectedSort = 'latest',
    this.selectedKindSlug,
    this.selectedType,
    this.errorMessage,
  });

  StoriesFeedState copyWith({
    StoriesFeedStatus? status,
    List<StoryListItemEntity>? stories,
    List<StoryTypeEntity>? storyTypes,
    int? totalCount,
    int? offset,
    bool? hasMore,
    bool? isLoadingMore,
    String? searchQuery,
    String? selectedSort,
    String? Function()? selectedKindSlug,
    String? Function()? selectedType,
    String? errorMessage,
  }) {
    return StoriesFeedState(
      status: status ?? this.status,
      stories: stories ?? this.stories,
      storyTypes: storyTypes ?? this.storyTypes,
      totalCount: totalCount ?? this.totalCount,
      offset: offset ?? this.offset,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedSort: selectedSort ?? this.selectedSort,
      selectedKindSlug: selectedKindSlug != null ? selectedKindSlug() : this.selectedKindSlug,
      selectedType: selectedType != null ? selectedType() : this.selectedType,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        stories,
        storyTypes,
        totalCount,
        offset,
        hasMore,
        isLoadingMore,
        searchQuery,
        selectedSort,
        selectedKindSlug,
        selectedType,
        errorMessage,
      ];
}

