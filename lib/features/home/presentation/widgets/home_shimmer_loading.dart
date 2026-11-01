import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_shimmer.dart';

/// Pixel-perfect skeleton shimmer matching the complete layout of HomeFeedScreen.
/// Preserves heritage aesthetic with zero visual layout shift when real content arrives.
class HomeShimmerLoading extends StatelessWidget {
  const HomeShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 120.h),
        children: [
          // 1. Hero Carousel Placeholder
          Container(
            height: 380.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: ColorManager.primaryLight,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ShimmerBox(width: 80.w, height: 14.h),
                  SizedBox(height: 10.h),
                  ShimmerBox(width: 240.w, height: 24.h),
                  SizedBox(height: 12.h),
                  ShimmerBox(width: double.infinity, height: 12.h),
                  SizedBox(height: 6.h),
                  ShimmerBox(width: 200.w, height: 12.h),
                  SizedBox(height: 18.h),
                  Row(
                    children: [
                      ShimmerBox(width: 110.w, height: 34.h, borderRadius: 20.r),
                      SizedBox(width: 10.w),
                      ShimmerBox(width: 100.w, height: 34.h, borderRadius: 20.r),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24.h),

          // 2. Section Header: Featured Story
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 70.w, height: 12.h),
                SizedBox(height: 6.h),
                ShimmerBox(width: 140.w, height: 18.h),
              ],
            ),
          ),

          SizedBox(height: 14.h),

          // 3. Featured Story Card Placeholder
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: ShimmerBox(
              width: double.infinity,
              height: 224.h,
              borderRadius: 12.r,
            ),
          ),

          SizedBox(height: 32.h),

          // 4. Section Header: Top Stories
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 80.w, height: 12.h),
                    SizedBox(height: 6.h),
                    ShimmerBox(width: 130.w, height: 18.h),
                  ],
                ),
                ShimmerBox(width: 45.w, height: 14.h),
              ],
            ),
          ),

          SizedBox(height: 14.h),

          // 5. Horizontal Top Stories Cards Placeholder
          SizedBox(
            height: 200.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 180.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 180.w, height: 128.h, borderRadius: 8.r),
                      SizedBox(height: 8.h),
                      ShimmerBox(width: 160.w, height: 14.h),
                      SizedBox(height: 6.h),
                      ShimmerBox(width: 100.w, height: 12.h),
                    ],
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 32.h),

          // 6. Section Header: Ambassadors
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 60.w, height: 12.h),
                SizedBox(height: 6.h),
                ShimmerBox(width: 110.w, height: 18.h),
              ],
            ),
          ),

          SizedBox(height: 14.h),

          // 7. Horizontal Ambassadors List Placeholder
          SizedBox(
            height: 144.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => SizedBox(width: 14.w),
              itemBuilder: (context, index) {
                return ShimmerBox(width: 140.w, height: 144.h, borderRadius: 8.r);
              },
            ),
          ),
        ],
      ),
    );
  }
}

