import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';

class SubmitStoryStepper extends StatelessWidget {
  final int currentStep;

  const SubmitStoryStepper({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: _StepItem(
              stepNumber: 1,
              label: 'submit.stepper.step1'.tr(),
              isActive: currentStep >= 1,
            ),
          ),
          _StepDivider(isActive: currentStep >= 2),
          Expanded(
            child: _StepItem(
              stepNumber: 2,
              label: 'submit.stepper.step2'.tr(),
              isActive: currentStep >= 2,
            ),
          ),
          _StepDivider(isActive: currentStep >= 3),
          Expanded(
            child: _StepItem(
              stepNumber: 3,
              label: 'submit.stepper.step3'.tr(),
              isActive: currentStep >= 3,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final int stepNumber;
  final String label;
  final bool isActive;

  const _StepItem({
    required this.stepNumber,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? ColorManager.gold : ColorManager.primaryLight.withValues(alpha: 0.4),
          ),
          child: Center(
            child: Text(
              stepNumber.toString(),
              style: AppFonts.ibmPlexSansArabic(
                color: isActive ? ColorManager.primaryDark : ColorManager.paper400,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 5.w),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppFonts.ibmPlexSansArabic(
              color: isActive ? ColorManager.gold : ColorManager.paper400,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _StepDivider extends StatelessWidget {
  final bool isActive;

  const _StepDivider({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14.w,
      height: 1.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      color: isActive ? ColorManager.gold : ColorManager.gold.withValues(alpha: 0.2),
    );
  }
}

