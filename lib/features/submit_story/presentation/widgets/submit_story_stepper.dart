import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _StepItem(
            stepNumber: 1,
            label: 'اختار نوع الحكاية',
            isActive: currentStep >= 1,
          ),
          _StepDivider(isActive: currentStep >= 2),
          _StepItem(
            stepNumber: 2,
            label: 'مراجعة',
            isActive: currentStep >= 2,
          ),
          _StepDivider(isActive: currentStep >= 3),
          _StepItem(
            stepNumber: 3,
            label: 'تأكيد وإرسال',
            isActive: currentStep >= 3,
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
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? ColorManager.gold : ColorManager.primaryLight.withValues(alpha: 0.4),
          ),
          child: Center(
            child: Text(
              stepNumber.toString(),
              style: GoogleFonts.ibmPlexSansArabic(
                color: isActive ? ColorManager.primaryDark : ColorManager.paper400,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: GoogleFonts.ibmPlexSansArabic(
            color: isActive ? ColorManager.gold : ColorManager.paper400,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
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
      width: 20.w,
      height: 1.h,
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      color: isActive ? ColorManager.gold : ColorManager.gold.withValues(alpha: 0.2),
    );
  }
}

