import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';

class StoryRatingSection extends StatefulWidget {
  const StoryRatingSection({super.key});

  @override
  State<StoryRatingSection> createState() => _StoryRatingSectionState();
}

class _StoryRatingSectionState extends State<StoryRatingSection> {
  int _userRating = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: ColorManager.gold.withValues(alpha: 0.15)),
        ),
      ),
      child: Column(
        children: [
          Text(
            'قيّم الحكاية',
            style: GoogleFonts.ibmPlexSansArabic(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: ColorManager.paper200,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              final isFilled = starIndex <= _userRating;
              return InkWell(
                onTap: () {
                  setState(() => _userRating = starIndex);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Icon(
                    isFilled ? CupertinoIcons.star_fill : CupertinoIcons.star,
                    size: 26.sp,
                    color: isFilled ? ColorManager.gold : ColorManager.paper400,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

