import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_cached_network_image.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';

/// Horizontal Story-card list representing fleeting moments.
class HomeMomentsList extends StatelessWidget {
  final List<MomentFeedItemEntity> moments;
  final ValueChanged<int> onMomentTap;

  const HomeMomentsList({
    super.key,
    required this.moments,
    required this.onMomentTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 165.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: moments.length,
        separatorBuilder: (context, index) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final moment = moments[index];
          return InkWell(
            onTap: () => onMomentTap(index),
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              width: 110.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: ColorManager.goldLight.withValues(alpha: 0.6),
                  width: 1.2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (moment.imageUrl != null && moment.imageUrl!.isNotEmpty)
                      AppCachedNetworkImage(
                        imageUrl: moment.imageUrl!,
                        fit: BoxFit.cover,
                        memCacheWidth: 220,
                        memCacheHeight: 330,
                      )
                    else
                      Container(
                        color: ColorManager.primaryLight,
                        child: const Icon(
                          CupertinoIcons.photo,
                          color: ColorManager.paper400,
                        ),
                      ),
                    // Ambient gradient overlay
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Color(0xE6220610),
                          ],
                        ),
                      ),
                    ),
                    // Type Badge (Photo / Video)
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          moment.kind == MomentKind.video
                              ? CupertinoIcons.play_arrow_solid
                              : CupertinoIcons.camera_fill,
                          size: 11.sp,
                          color: ColorManager.goldLight,
                        ),
                      ),
                    ),
                    // Title at bottom
                    Positioned(
                      bottom: 8.h,
                      left: 8.w,
                      right: 8.w,
                      child: Text(
                        moment.title,
                        style: AppFonts.alexandria(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorManager.paper100,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
