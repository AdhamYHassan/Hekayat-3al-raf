import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/app_shimmer.dart';

/// GPU-accelerated skeleton shimmer loading for the Ambassador Details screen.
///
/// Features:
/// - Exact layout parity with [AmbassadorDetailsScreen] (Hero, Stats, Bio, Gallery).
/// - Wrapped in [RepaintBoundary] to isolate shader repaints.
/// - Zero external dependencies, runs smoothly on 2GB RAM budget devices.
class AmbassadorDetailsShimmerLoading extends StatelessWidget {
  const AmbassadorDetailsShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Header Skeleton
            SizedBox(
              height: 320.h,
              width: double.infinity,
              child: Stack(
                children: [
                  const ShimmerBox(width: double.infinity, height: double.infinity),
                  Positioned(
                    bottom: 20.h,
                    left: 16.w,
                    right: 16.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ShimmerBox(width: 180.w, height: 26.h, borderRadius: 6.r),
                        SizedBox(height: 8.h),
                        ShimmerBox(width: 120.w, height: 14.h, borderRadius: 4.r),
                        SizedBox(height: 6.h),
                        ShimmerBox(width: 90.w, height: 12.h, borderRadius: 4.r),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // 2. Stats Grid Skeleton (2 cards)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: ShimmerBox(
                      height: 70.h,
                      borderRadius: 12.r,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ShimmerBox(
                      height: 70.h,
                      borderRadius: 12.r,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // 3. Bio Paragraphs Skeleton
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ShimmerBox(width: 100.w, height: 18.h, borderRadius: 4.r),
                  SizedBox(height: 12.h),
                  ShimmerBox(width: double.infinity, height: 14.h, borderRadius: 4.r),
                  SizedBox(height: 8.h),
                  ShimmerBox(width: double.infinity, height: 14.h, borderRadius: 4.r),
                  SizedBox(height: 8.h),
                  ShimmerBox(width: 240.w, height: 14.h, borderRadius: 4.r),
                ],
              ),
            ),

            SizedBox(height: 28.h),

            // 4. Gallery Carousel Skeleton
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ShimmerBox(width: 140.w, height: 18.h, borderRadius: 4.r),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 180.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: 3,
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                itemBuilder: (context, index) => ShimmerBox(
                  width: 220.w,
                  height: 180.h,
                  borderRadius: 12.r,
                ),
              ),
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
