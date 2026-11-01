import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/bloc/ambassador_details_cubit.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/bloc/ambassador_details_state.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/widgets/ambassador_details_shimmer_loading.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/widgets/ambassador_gallery_carousel.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/widgets/ambassador_hero_header.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/widgets/ambassador_qa_section.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/widgets/ambassador_selected_stories_list.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/widgets/ambassador_stats_grid.dart';

class AmbassadorDetailsScreen extends StatelessWidget {
  final String ambassadorId;

  const AmbassadorDetailsScreen({
    super.key,
    required this.ambassadorId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AmbassadorDetailsCubit>(
      create: (context) => getIt<AmbassadorDetailsCubit>()
        ..loadAmbassadorDetails(ambassadorId),
      child: const _AmbassadorDetailsView(),
    );
  }
}

class _AmbassadorDetailsView extends StatelessWidget {
  const _AmbassadorDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryDark,
      body: BlocConsumer<AmbassadorDetailsCubit, AmbassadorDetailsState>(
        listener: (context, state) {
          if (state.questionSubmitSuccess != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.questionSubmitSuccess!,
                  style: GoogleFonts.ibmPlexSansArabic(color: ColorManager.paper100),
                ),
                backgroundColor: ColorManager.primaryLight,
              ),
            );
          }
          if (state.errorMessage != null && state.status == AmbassadorStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage!,
                  style: GoogleFonts.ibmPlexSansArabic(color: Colors.white),
                ),
                backgroundColor: Colors.red.shade900,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == AmbassadorStatus.loading ||
              state.status == AmbassadorStatus.initial) {
            return const AmbassadorDetailsShimmerLoading();
          }

          if (state.details == null) {
            return Center(
              child: Text(
                'تعذر تحميل بيانات السفير',
                style: GoogleFonts.ibmPlexSansArabic(
                  color: ColorManager.paper200,
                  fontSize: 14.sp,
                ),
              ),
            );
          }

          final details = state.details!;

          return Stack(
            children: [
              // Scrollable Content
              CustomScrollView(
                slivers: [
                  // 1. Hero Cover Header
                  SliverToBoxAdapter(
                    child: AmbassadorHeroHeader(
                      name: details.name,
                      role: details.role,
                      cityAndJoin: '${details.city} · ${details.joinYear}',
                      coverImageUrl: details.coverImageUrl,
                    ),
                  ),

                  // 2. Body Sections
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Philosophy Quote with Gold border
                          Container(
                            padding: EdgeInsetsDirectional.only(start: 12.w, top: 4.h, bottom: 4.h),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: ColorManager.gold,
                                  width: 2.5.w,
                                ),
                              ),
                            ),
                            child: Text(
                              details.quote,
                              style: GoogleFonts.arefRuqaa(
                                color: ColorManager.goldLight,
                                fontSize: 16.sp,
                                fontStyle: FontStyle.italic,
                                height: 1.6,
                              ),
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // Tags Chips
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: details.tags.map((tag) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: ColorManager.gold.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border.all(
                                      color: ColorManager.gold.withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    tag,
                                    style: GoogleFonts.ibmPlexSansArabic(
                                      color: ColorManager.goldLight,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),

                          SizedBox(height: 16.h),

                          // Stats Grid
                          AmbassadorStatsGrid(
                            storiesCount: details.storiesCount,
                            answeredQuestionsCount: details.answeredQuestionsCount,
                          ),

                          SizedBox(height: 18.h),

                          // Bio Paragraphs
                          ...details.bioParagraphs.map(
                            (p) => Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: Text(
                                p,
                                style: GoogleFonts.ibmPlexSansArabic(
                                  color: ColorManager.paper200.withValues(alpha: 0.8),
                                  fontSize: 13.5.sp,
                                  height: 1.8,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 8.h),

                          // Pull Quote in calligraphy
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(vertical: 8.h),
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: ColorManager.primaryLight.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: ColorManager.gold.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Text(
                              '«${details.pullQuote}»',
                              style: GoogleFonts.arefRuqaa(
                                color: ColorManager.goldLight,
                                fontSize: 15.sp,
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 3. Photo Gallery Carousel
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: AmbassadorGalleryCarousel(items: details.gallery),
                    ),
                  ),

                  // 4. Selected Stories
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: AmbassadorSelectedStoriesList(
                        stories: details.selectedStories,
                        onStoryTap: (story) {
                          // Tap handler for navigating to story details if needed
                        },
                      ),
                    ),
                  ),

                  // 5. Q&A Section with Interactive Form
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 40.h),
                      child: AmbassadorQaSection(
                        questions: details.questions,
                        isSubmitting: state.isSubmittingQuestion,
                        onSubmitQuestion: (name, city, question) {
                          context.read<AmbassadorDetailsCubit>().submitQuestion(
                                ambassadorId: details.id,
                                authorName: name,
                                city: city,
                                question: question,
                              );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // Fixed Top Navigation Bar with subtle transparent back button
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button with soft frosted backdrop
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(20.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: ColorManager.primaryDark.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: ColorManager.goldLight,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'رجوع',
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    color: ColorManager.goldLight,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

