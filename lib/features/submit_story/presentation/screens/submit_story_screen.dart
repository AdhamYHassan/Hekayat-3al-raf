import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/bloc/submit_story_cubit.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/bloc/submit_story_state.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/widgets/story_type_card.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/widgets/submit_story_review_info_card.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/widgets/submit_story_stepper.dart';

class SubmitStoryScreen extends StatelessWidget {
  const SubmitStoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SubmitStoryCubit>(
      create: (context) => getIt<SubmitStoryCubit>(),
      child: const _SubmitStoryView(),
    );
  }
}

class _SubmitStoryView extends StatelessWidget {
  const _SubmitStoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryDark,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<SubmitStoryCubit, SubmitStoryState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                // 1. Header (Title & Subtitle)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'احكي حكايتك',
                          style: GoogleFonts.alexandria(
                            color: ColorManager.paper100,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'كل تجربة تستحق أن تُسمع. اختار الطريقة اللي تناسبك، وإحنا هنوصلها للي يحتاج يسمعها.',
                          style: GoogleFonts.ibmPlexSansArabic(
                            color: ColorManager.paper200.withValues(alpha: 0.65),
                            fontSize: 13.sp,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Stepper
                SliverToBoxAdapter(
                  child: SubmitStoryStepper(currentStep: state.currentStep),
                ),

                // 3. Section Title Indicator
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Row(
                      children: [
                        Container(
                          width: 18.w,
                          height: 1.5.h,
                          color: ColorManager.gold,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'اختار نوع الحكاية',
                          style: GoogleFonts.ibmPlexSansArabic(
                            color: ColorManager.gold,
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 4. Story Type Cards List
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  sliver: SliverList.separated(
                    itemCount: state.storyOptions.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final option = state.storyOptions[index];
                      final isSelected = state.selectedFormat == option.format;
                      return StoryTypeCard(
                        option: option,
                        isSelected: isSelected,
                        onTap: () {
                          context
                              .read<SubmitStoryCubit>()
                              .selectFormat(option.format);
                        },
                      );
                    },
                  ),
                ),

                // Dynamic Next Button when an option is selected
                if (state.selectedFormat != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context.read<SubmitStoryCubit>().setStep(2);
                          },
                          borderRadius: BorderRadius.circular(30.r),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFE8CB7D),
                                  Color(0xFFC9A24B),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 13.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'التالي',
                                  style: GoogleFonts.alexandria(
                                    color: ColorManager.primaryDark,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Icon(
                                  Icons.chevron_left_rounded,
                                  color: ColorManager.primaryDark,
                                  size: 18.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // 5. Review Info Card & Bottom Margin
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 120.h),
                    child: SubmitStoryReviewInfoCard(steps: state.reviewSteps),
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

