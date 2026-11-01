import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_shimmer.dart';

/// Pixel-perfect skeleton shimmer matching the layout of StoryDetailsScreen.
/// Preserves heritage aesthetic with zero visual layout shift when story loads.
class StoryDetailsShimmerLoading extends StatelessWidget {
  const StoryDetailsShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 40.h),
        children: [
          // 1. Hero Cover Placeholder with gradient look
          Container(
            height: 288.h,
            width: double.infinity,
            color: ColorManager.primaryLight,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ShimmerBox(width: 70.w, height: 16.h, borderRadius: 12.r),
                  SizedBox(height: 10.h),
                  ShimmerBox(width: 260.w, height: 24.h),
                  SizedBox(height: 8.h),
                  ShimmerBox(width: 140.w, height: 14.h),
                ],
              ),
            ),
          ),

          // 2. Stats Bar Placeholder
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ShimmerBox(width: 60.w, height: 14.h),
                    SizedBox(width: 14.w),
                    ShimmerBox(width: 50.w, height: 14.h),
                  ],
                ),
                ShimmerBox(width: 70.w, height: 20.h, borderRadius: 4.r),
              ],
            ),
          ),

          // 3. Media Player Card Placeholder (Audio or Video Card)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              height: 140.h,
              decoration: BoxDecoration(
                color: ColorManager.primaryLight.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: ColorManager.gold.withValues(alpha: 0.1),
                ),
              ),
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ShimmerBox(width: 44.w, height: 44.w, borderRadius: 22.r),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(width: 160.w, height: 14.h),
                          SizedBox(height: 6.h),
                          ShimmerBox(width: 100.w, height: 11.h),
                        ],
                      ),
                    ],
                  ),
                  ShimmerBox(width: double.infinity, height: 6.h, borderRadius: 3.r),
                ],
              ),
            ),
          ),

          SizedBox(height: 24.h),

          // 4. Narrative Body Paragraphs Placeholder
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: double.infinity, height: 14.h),
                SizedBox(height: 8.h),
                ShimmerBox(width: 280.w, height: 14.h),
                SizedBox(height: 16.h),
                ShimmerBox(width: double.infinity, height: 12.h),
                SizedBox(height: 8.h),
                ShimmerBox(width: double.infinity, height: 12.h),
                SizedBox(height: 8.h),
                ShimmerBox(width: 220.w, height: 12.h),
              ],
            ),
          ),

          SizedBox(height: 32.h),

          // 5. Rating Section Placeholder
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Center(
              child: Column(
                children: [
                  ShimmerBox(width: 90.w, height: 14.h),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: ShimmerBox(width: 28.w, height: 28.w, borderRadius: 14.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

