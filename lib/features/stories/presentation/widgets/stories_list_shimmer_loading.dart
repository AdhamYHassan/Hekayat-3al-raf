import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/app_shimmer.dart';

/// Skeleton loading for the Stories Feed Screen rendered as a sliver.
class StoriesListShimmerLoading extends StatelessWidget {
  const StoriesListShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 120.h),
      sliver: SliverList.separated(
        itemCount: 5,
        separatorBuilder: (context, index) => SizedBox(height: 12.h),
        itemBuilder: (context, index) => AppShimmer(
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 96.w, height: 96.h, borderRadius: 8.r),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(width: 70.w, height: 16.h, borderRadius: 10.r),
                      SizedBox(height: 8.h),
                      ShimmerBox(width: double.infinity, height: 14.h, borderRadius: 4.r),
                      SizedBox(height: 6.h),
                      ShimmerBox(width: 180.w, height: 12.h, borderRadius: 4.r),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ShimmerBox(width: 90.w, height: 10.h, borderRadius: 4.r),
                          ShimmerBox(width: 50.w, height: 10.h, borderRadius: 4.r),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
