import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/routing/routes.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_back_button.dart';
import 'package:hekayat_3al_raf/core/widgets/app_snack_bar.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/bloc/ambassador_details_cubit.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/bloc/ambassador_details_state.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/widgets/ambassador_details_shimmer_loading.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/widgets/ambassador_gallery_carousel.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/widgets/ambassador_hero_header.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/widgets/ambassador_qa_section.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/widgets/ambassador_stats_grid.dart';

class AmbassadorDetailsScreen extends StatelessWidget {
  final String ambassadorSlug;

  const AmbassadorDetailsScreen({super.key, required this.ambassadorSlug});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AmbassadorDetailsCubit>()..loadAmbassadorDetails(ambassadorSlug),
      child: Scaffold(
        backgroundColor: ColorManager.primaryDark,
        body: BlocConsumer<AmbassadorDetailsCubit, AmbassadorDetailsState>(
          listener: (context, state) {
            // Handle Question Submission Success
            if (state.questionSubmitSuccess != null) {
              AppSnackBar.showSuccess(
                context,
                message: state.questionSubmitSuccess!,
              );
            }

            // Handle Error Messages
            if (state.errorMessage != null) {
              final error = state.errorMessage!;
              final is401 = error.contains('401') ||
                  error.contains('بيانات الدخول') ||
                  error.contains('لم يتم تزويد') ||
                  error.contains('Given token not valid') ||
                  error.toLowerCase().contains('unauthorized') ||
                  error.toLowerCase().contains('authentication credentials');

              if (is401) {
                AppSnackBar.showAuthRequired(
                  context,
                  message: 'auth.login_required'.tr(),
                  onLoginTap: () => context.push(Routes.login),
                );
              } else if (state.details != null) {
                // Inline action error (e.g. question submit failed)
                AppSnackBar.showError(context, message: error);
              }
            }
          },
          builder: (context, state) {
            if (state.status == AmbassadorStatus.loading) {
              return const AmbassadorDetailsShimmerLoading();
            }

            if (state.errorMessage != null && state.details == null) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: ColorManager.gold,
                        size: 48.sp,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        state.errorMessage!,
                        textAlign: TextAlign.center,
                        style: AppFonts.ibmPlexSansArabic(
                          color: ColorManager.paper200,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () => context
                            .read<AmbassadorDetailsCubit>()
                            .loadAmbassadorDetails(ambassadorSlug),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.gold,
                          foregroundColor: ColorManager.primaryDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          'common.retry'.tr(),
                          style: AppFonts.ibmPlexSansArabic(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final details = state.details;
            if (details == null) return const SizedBox.shrink();

            return Stack(
              children: [
                // Scrollable Content
                CustomScrollView(
                  slivers: [
                    // 1. Hero Cover Header
                    SliverToBoxAdapter(
                      child: AmbassadorHeroHeader(
                        name: details.name,
                        shortDescription: details.shortDescription,
                        coverImageUrl: details.coverImageUrl,
                      ),
                    ),

                    // 2. Stats Grid & Biography
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Stats Grid: Followers & Answered Count
                            AmbassadorStatsGrid(
                              followersCount: details.followersCount,
                              answeredCount: details.answeredCount,
                            ),

                            if (details.description.isNotEmpty) ...[
                              SizedBox(height: 20.h),
                              Text(
                                'ambassadors.about_ambassador'.tr(),
                                style: AppFonts.alexandria(
                                  color: ColorManager.paper100,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                details.description,
                                style: AppFonts.ibmPlexSansArabic(
                                  color: ColorManager.paper200
                                      .withValues(alpha: 0.85),
                                  fontSize: 14.sp,
                                  height: 1.8,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    // 3. Photo Gallery Carousel (media from API)
                    if (details.gallery.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child:
                              AmbassadorGalleryCarousel(items: details.gallery),
                        ),
                      ),

                    // 4. Q&A Section with Interactive Form
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 40.h),
                        child: AmbassadorQaSection(
                          questions: details.questions,
                          isSubmitting: state.isSubmittingQuestion,
                          onSubmitQuestion: (question) {
                            context
                                .read<AmbassadorDetailsCubit>()
                                .submitQuestion(
                                  ambassadorSlug: details.id,
                                  body: question,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Back Button with soft frosted backdrop
                          const AppBackButton(withBackground: true),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
