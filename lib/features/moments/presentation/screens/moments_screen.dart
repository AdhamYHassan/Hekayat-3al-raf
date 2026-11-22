import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/routing/routes.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_cached_network_image.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';
import 'package:hekayat_3al_raf/features/moments/presentation/bloc/moments_list_cubit.dart';
import 'package:hekayat_3al_raf/features/moments/presentation/bloc/moments_list_state.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/widgets/story_detail_header.dart';

class MomentsScreen extends StatelessWidget {
  const MomentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MomentsListCubit>(
      create: (context) => getIt<MomentsListCubit>()..loadMoments(),
      child: const _MomentsView(),
    );
  }
}

class _MomentsView extends StatelessWidget {
  const _MomentsView();

  bool _onScrollNotification(
    ScrollNotification notification,
    BuildContext context,
  ) {
    if (notification is ScrollUpdateNotification) {
      final metrics = notification.metrics;
      if (metrics.pixels >= metrics.maxScrollExtent * 0.85) {
        context.read<MomentsListCubit>().loadMoreMoments();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            StoryDetailHeader(onBackTap: () => Navigator.of(context).pop()),
            Expanded(
              child: BlocBuilder<MomentsListCubit, MomentsListState>(
                builder: (context, state) {
                  if (state.status == MomentsListStatus.loading ||
                      state.status == MomentsListStatus.initial) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.gold,
                      ),
                    );
                  }

                  if (state.status == MomentsListStatus.failure &&
                      state.moments.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              state.errorMessage ??
                                  'common.server_error'.tr(),
                              textAlign: TextAlign.center,
                              style: AppFonts.ibmPlexSansArabic(
                                color: ColorManager.paper200,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<MomentsListCubit>()
                                  .loadMoments(isRefresh: true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.gold,
                                foregroundColor: ColorManager.primaryDark,
                              ),
                              child: Text('common.retry'.tr()),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state.moments.isEmpty) {
                    return Center(
                      child: Text(
                        'common.no_data'.tr(),
                        style: AppFonts.ibmPlexSansArabic(
                          color: ColorManager.paper200,
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (notification) =>
                        _onScrollNotification(notification, context),
                    child: RefreshIndicator(
                      color: ColorManager.gold,
                      backgroundColor: ColorManager.primaryLight,
                      onRefresh: () => context
                          .read<MomentsListCubit>()
                          .loadMoments(isRefresh: true),
                      child: GridView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: state.moments.length +
                            (state.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= state.moments.length) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: ColorManager.gold,
                                strokeWidth: 2,
                              ),
                            );
                          }

                          final moment = state.moments[index];
                          return InkWell(
                            onTap: () {
                              context.push(
                                Routes.momentDetails,
                                extra: {'id': moment.id},
                              );
                            },
                            borderRadius: BorderRadius.circular(12.r),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: ColorManager.goldLight
                                      .withValues(alpha: 0.6),
                                  width: 1.2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(11.r),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    if (moment.imageUrl != null &&
                                        moment.imageUrl!.isNotEmpty)
                                      AppCachedNetworkImage(
                                        imageUrl: moment.imageUrl!,
                                        fit: BoxFit.cover,
                                        memCacheWidth: 360,
                                        memCacheHeight: 480,
                                      )
                                    else
                                      Container(
                                        color: ColorManager.primaryLight,
                                        child: const Icon(
                                          CupertinoIcons.photo,
                                          color: ColorManager.paper400,
                                        ),
                                      ),
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
                                    Positioned(
                                      top: 8.h,
                                      right: 8.w,
                                      child: Container(
                                        padding: EdgeInsets.all(5.w),
                                        decoration: BoxDecoration(
                                          color: Colors.black
                                              .withValues(alpha: 0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          moment.kind == MomentKind.video
                                              ? CupertinoIcons.play_arrow_solid
                                              : CupertinoIcons.camera_fill,
                                          size: 12.sp,
                                          color: ColorManager.goldLight,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10.h,
                                      left: 10.w,
                                      right: 10.w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            moment.title,
                                            style: AppFonts.alexandria(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700,
                                              color: ColorManager.paper100,
                                              height: 1.25,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (moment.created.isNotEmpty) ...[
                                            SizedBox(height: 4.h),
                                            Text(
                                              moment.created.split('T').first,
                                              style:
                                                  AppFonts.ibmPlexSansArabic(
                                                fontSize: 10.sp,
                                                color: ColorManager.paper400,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
