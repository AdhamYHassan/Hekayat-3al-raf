import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_entities.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/bloc/submit_story_cubit.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/bloc/submit_story_state.dart';
import 'package:hekayat_3al_raf/features/submit_story/presentation/widgets/submit_story_step2_form.dart';
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
        return 'حكاية مكتوبة';
      case StorySubmissionFormat.audio:
        return 'حكاية صوتية';
      case StorySubmissionFormat.video:
        return 'حكاية مصورة';
      case StorySubmissionFormat.document:
        return 'وثيقة ومستند';
    }
  }

  @override
  Widget build(BuildContext context) {
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
          children: [
            Text(
              _getFormatTitle(format),
              style: GoogleFonts.alexandria(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: ColorManager.paper100,
              ),
            ),
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(20.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'رجوع',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorManager.goldLight,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      CupertinoIcons.arrow_left,
                      size: 14.sp,
                      color: ColorManager.goldLight,
                    ),
                  ],
                ),
              ),
            ),
          ],
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

