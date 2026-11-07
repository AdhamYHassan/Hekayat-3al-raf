import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_shimmer.dart';

class ProfileShimmerLoading extends StatelessWidget {
  const ProfileShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          // 1. App Bar Placeholder
          SliverAppBar(
            backgroundColor: ColorManager.primaryDark,
            pinned: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 16.w,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(
                  width: 120.w,
                  height: 28.h,
                  borderRadius: 6.r,
                ),
                ShimmerBox(
                  width: 60.w,
                  height: 24.h,
                  borderRadius: 12.r,
                ),
              ],
            ),
          ),

          // 2. Profile Hero Header Skeleton
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 260.h,
                  color: ColorManager.primary.withValues(alpha: 0.3),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 20.h),
                  child: Column(
                    children: [
                      // Avatar circle skeleton
                      Center(
                        child: ShimmerBox(
                          width: 96.r,
                          height: 96.r,
                          shape: const CircleBorder(),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // User Name skeleton
                      ShimmerBox(
                        width: 140.w,
                        height: 20.h,
                        borderRadius: 6.r,
                      ),
                      SizedBox(height: 8.h),

                      // City & Date skeleton
                      ShimmerBox(
                        width: 180.w,
                        height: 12.h,
                        borderRadius: 4.r,
                      ),
                      SizedBox(height: 14.h),

                      // Bio lines skeleton
                      ShimmerBox(
                        width: 240.w,
                        height: 11.h,
                        borderRadius: 4.r,
                      ),
                      SizedBox(height: 6.h),
                      ShimmerBox(
                        width: 190.w,
                        height: 11.h,
                        borderRadius: 4.r,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Contact Info Section Skeleton
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ShimmerBox(width: 20.w, height: 2.h, borderRadius: 1.r),
                      SizedBox(width: 8.w),
                      ShimmerBox(width: 90.w, height: 14.h, borderRadius: 4.r),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  _buildShimmerContactCard(),
                  SizedBox(height: 8.h),
                  _buildShimmerContactCard(),
                  SizedBox(height: 8.h),
                  _buildShimmerContactCard(),
                ],
              ),
            ),
          ),

          // 4. Menu Options Section Skeleton
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ShimmerBox(width: 20.w, height: 2.h, borderRadius: 1.r),
                      SizedBox(width: 8.w),
                      ShimmerBox(width: 60.w, height: 14.h, borderRadius: 4.r),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  _buildShimmerMenuItemCard(),
                  SizedBox(height: 8.h),
                  _buildShimmerMenuItemCard(),
                  SizedBox(height: 8.h),
                  _buildShimmerMenuItemCard(),
                  SizedBox(height: 8.h),
                  _buildShimmerMenuItemCard(),
                  SizedBox(height: 24.h),

                  // Logout button skeleton
                  Center(
                    child: ShimmerBox(
                      width: 140.w,
                      height: 40.h,
                      borderRadius: 30.r,
                    ),
                  ),
                  SizedBox(height: 60.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerContactCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorManager.primaryLight.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorManager.gold.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          ShimmerBox(
            width: 36.r,
            height: 36.r,
            shape: const CircleBorder(),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 50.w, height: 10.h, borderRadius: 3.r),
                SizedBox(height: 6.h),
                ShimmerBox(width: 130.w, height: 13.h, borderRadius: 4.r),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerMenuItemCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: ColorManager.primaryLight.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorManager.gold.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          ShimmerBox(
            width: 38.r,
            height: 38.r,
            shape: const CircleBorder(),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 100.w, height: 13.h, borderRadius: 4.r),
                SizedBox(height: 6.h),
                ShimmerBox(width: 150.w, height: 10.h, borderRadius: 3.r),
              ],
            ),
          ),
          ShimmerBox(width: 16.r, height: 16.r, borderRadius: 4.r),
        ],
      ),
    );
  }
}

