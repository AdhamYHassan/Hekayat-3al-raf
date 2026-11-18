import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/widgets/app_shimmer.dart';

class MyMessagesShimmerLoading extends StatelessWidget {
  const MyMessagesShimmerLoading({super.key});

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
            SizedBox(height: 24.h),

            // 3 Message Card Shimmers
            ...List.generate(
              3,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: ShimmerBox(
                  width: double.infinity,
                  height: 120.h,
                  borderRadius: 14.r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
