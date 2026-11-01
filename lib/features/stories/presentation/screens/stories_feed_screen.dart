import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/theming/colors_manager.dart';
import '../../../../core/utils/debouncer.dart';
import '../bloc/stories_feed_cubit.dart';
import '../bloc/stories_feed_state.dart';
import '../widgets/stories_filter_header.dart';
import '../widgets/stories_list_shimmer_loading.dart';
import '../widgets/story_card_item.dart';

class StoriesFeedScreen extends StatelessWidget {
  const StoriesFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StoriesFeedCubit>(
      create: (context) => getIt<StoriesFeedCubit>()..loadInitialData(),
      child: const _StoriesFeedView(),
    );
  }
}

class _StoriesFeedView extends StatefulWidget {
  const _StoriesFeedView();

  @override
  State<_StoriesFeedView> createState() => _StoriesFeedViewState();
}

class _StoriesFeedViewState extends State<_StoriesFeedView> {
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 350));

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final metrics = notification.metrics;
      if (metrics.pixels >= metrics.maxScrollExtent * 0.85) {
        context.read<StoriesFeedCubit>().loadMoreStories();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryDark,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<StoriesFeedCubit, StoriesFeedState>(
          builder: (context, state) {
            return NotificationListener<ScrollNotification>(
              onNotification: _onScrollNotification,
              child: CustomScrollView(
                slivers: [
                  // 1. Sticky / Persistent Filter Header
                  SliverToBoxAdapter(
                    child: StoriesFilterHeader(
                      searchController: _searchController,
                      selectedSort: state.selectedSort,
                      selectedKindSlug: state.selectedKindSlug,
                      selectedType: state.selectedType,
                      storyTypes: state.storyTypes,
                      onSearchChanged: (val) {
                        _debouncer.run(() {
                          context.read<StoriesFeedCubit>().onSearchChanged(val);
                        });
                      },
                      onSortSelected: (sort) {
                        context.read<StoriesFeedCubit>().onSortChanged(sort);
                      },
                      onKindSelected: (kindSlug) {
                        context.read<StoriesFeedCubit>().onKindChanged(kindSlug);
                      },
                      onTypeSelected: (type) {
                        context.read<StoriesFeedCubit>().onTypeChanged(type);
                      },
                    ),
                  ),

                  // 2. Count Label
                  if (state.status == StoriesFeedStatus.success)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
                        child: Text(
                          '${state.totalCount} حكاية',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11.sp,
                            color: ColorManager.paper400,
                          ),
                        ),
                      ),
                    ),

                  // 3. Main Content: Shimmer vs Empty vs Error vs List
                  if (state.status == StoriesFeedStatus.loading && state.stories.isEmpty)
                    const StoriesListShimmerLoading()
                  else if (state.status == StoriesFeedStatus.failure && state.stories.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.errorMessage ?? 'تعذر تحميل الحكايات',
                              style: GoogleFonts.ibmPlexSansArabic(
                                color: ColorManager.paper200,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            ElevatedButton(
                              onPressed: () => context.read<StoriesFeedCubit>().loadInitialData(),
                              style: ElevatedButton.styleFrom(backgroundColor: ColorManager.gold),
                              child: Text(
                                'إعادة المحاولة',
                                style: GoogleFonts.alexandria(color: ColorManager.primaryDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (state.status == StoriesFeedStatus.success && state.stories.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'لا توجد حكايات مطابقة للبحث أو التصفية',
                          style: GoogleFonts.ibmPlexSansArabic(
                            color: ColorManager.paper300,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                      sliver: SliverList.separated(
                        itemCount: state.stories.length,
                        separatorBuilder: (context, index) => SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final story = state.stories[index];
                          return StoryCardItem(
                            id: story.id,
                            title: story.title,
                            summary: story.summary,
                            authorName: story.authorName,
                            city: story.storyType?.name ?? 'مصر',
                            coverImageUrl: story.coverImage,
                            submissionTypeLabel: story.submissionTypeLabel,
                            mediaType: story.mediaType,
                            category: story.storyType?.name ?? '',
                            viewsFormatted: story.viewsFormatted,
                            ratingFormatted: '${story.likes}',
                            onTap: () {
                              context.push(
                                Routes.storyDetails,
                                extra: {'id': story.id},
                              );
                            },
                          );
                        },
                      ),
                    ),

                  // 4. Bottom Infinite Scroll Pagination Indicator
                  if (state.isLoadingMore)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: ColorManager.gold,
                          ),
                        ),
                      ),
                    ),

                  SliverToBoxAdapter(
                    child: SizedBox(height: 100.h),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
