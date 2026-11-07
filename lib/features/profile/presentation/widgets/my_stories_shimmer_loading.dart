import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_shimmer.dart';

class MyStoriesShimmerLoading extends StatelessWidget {
  const MyStoriesShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            // Back button placeholder
            ShimmerBox(width: 120.w, height: 16.h, borderRadius: 4.r),
            SizedBox(height: 16.h),
            // Kicker line & title
            Row(
              children: [
                ShimmerBox(width: 20.w, height: 2.h, borderRadius: 1.r),
                SizedBox(width: 8.w),
                ShimmerBox(width: 60.w, height: 12.h, borderRadius: 4.r),
              ],
            ),
            SizedBox(height: 8.h),
            ShimmerBox(width: 180.w, height: 22.h, borderRadius: 6.r),
            SizedBox(height: 20.h),

            // 3 Stat counter boxes
            Row(
              children: [
                Expanded(
                  child: ShimmerBox(
                    height: 64.h,
                    borderRadius: 10.r,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ShimmerBox(
                    height: 64.h,
                    borderRadius: 10.r,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ShimmerBox(
                    height: 64.h,
                    borderRadius: 10.r,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Story Card Skeletons
            _buildCardSkeleton(),
            SizedBox(height: 12.h),
            _buildCardSkeleton(),
            SizedBox(height: 12.h),
            _buildCardSkeleton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardSkeleton() {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: ColorManager.primaryLight.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorManager.gold.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            width: 80.r,
            height: 80.r,
            borderRadius: 10.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerBox(width: 50.w, height: 16.h, borderRadius: 10.r),
                    SizedBox(width: 6.w),
                    ShimmerBox(width: 65.w, height: 16.h, borderRadius: 10.r),
                  ],
                ),
                SizedBox(height: 8.h),
                ShimmerBox(width: double.infinity, height: 14.h, borderRadius: 4.r),
                SizedBox(height: 6.h),
                ShimmerBox(width: 120.w, height: 14.h, borderRadius: 4.r),
                SizedBox(height: 10.h),
                ShimmerBox(width: 70.w, height: 10.h, borderRadius: 3.r),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
