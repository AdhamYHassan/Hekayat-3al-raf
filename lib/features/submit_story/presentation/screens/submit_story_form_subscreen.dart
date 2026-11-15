import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_back_button.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_entities.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/bloc/submit_story_cubit.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/bloc/submit_story_state.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/widgets/submit_story_step2_form.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/widgets/submit_story_step3_review.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/widgets/submit_story_stepper.dart';

class SubmitStoryFormSubscreen extends StatelessWidget {
  final StorySubmissionFormat format;

  const SubmitStoryFormSubscreen({
    super.key,
    required this.format,
  });

  String _getFormatTitle(StorySubmissionFormat format) {
    switch (format) {
      case StorySubmissionFormat.written:
        return 'submit.types.written'.tr();
      case StorySubmissionFormat.audio:
        return 'submit.types.audio'.tr();
      case StorySubmissionFormat.video:
        return 'submit.types.video'.tr();
      case StorySubmissionFormat.document:
        return 'submit.types.document'.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final titleWidget = Text(
      _getFormatTitle(format),
      style: AppFonts.alexandria(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: ColorManager.paper100,
      ),
    );
    const backWidget = AppBackButton();

    return Scaffold(
      backgroundColor: ColorManager.primaryDark,
      appBar: AppBar(
        backgroundColor: ColorManager.primaryDark,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        titleSpacing: 16.w,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: isArabic
              ? [titleWidget, backWidget]
              : [backWidget, titleWidget],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            color: ColorManager.gold.withValues(alpha: 0.15),
            height: 1.h,
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<SubmitStoryCubit, SubmitStoryState>(
          builder: (context, state) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12.h),
                  // Stepper showing Step 2 (أو Step 3 عند المراجعة)
                  SubmitStoryStepper(currentStep: state.currentStep),
                  SizedBox(height: 8.h),
                  if (state.currentStep == 3)
                    SubmitStoryStep3Review(format: format)
                  else
                    SubmitStoryStep2Form(format: format),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

