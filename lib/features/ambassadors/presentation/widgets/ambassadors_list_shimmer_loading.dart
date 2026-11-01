import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/app_shimmer.dart';

/// Skeleton loading for the Ambassadors List directory
class AmbassadorsListShimmerLoading extends StatelessWidget {
  const AmbassadorsListShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 120.h),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemBuilder: (context, index) => ShimmerBox(
          height: 180.h,
          borderRadius: 16.r,
        ),
      ),
    );
  }
}
