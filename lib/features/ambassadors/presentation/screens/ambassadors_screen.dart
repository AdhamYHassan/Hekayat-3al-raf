import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/routing/routes.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/bloc/ambassadors_list_cubit.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/bloc/ambassadors_list_state.dart';
import 'package:hekayat_3al_raf/features/ambassadors/presentation/widgets/ambassador_card_item.dart';

class AmbassadorsScreen extends StatelessWidget {
  const AmbassadorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AmbassadorsListCubit>(
      create: (context) => getIt<AmbassadorsListCubit>()..loadAmbassadors(),
      child: const _AmbassadorsView(),
    );
  }
}

class _AmbassadorsView extends StatelessWidget {
  const _AmbassadorsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryDark,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<AmbassadorsListCubit, AmbassadorsListState>(
          builder: (context, state) {
            if (state.status == AmbassadorsListStatus.loading ||
                state.status == AmbassadorsListStatus.initial) {
              return const Center(
                child: CircularProgressIndicator(color: ColorManager.gold),
              );
            }

            if (state.status == AmbassadorsListStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'تعذر تحميل السفراء',
                  style: GoogleFonts.ibmPlexSansArabic(
                    color: ColorManager.paper200,
                    fontSize: 14.sp,
                  ),
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                // Header (Title & Subtitle strictly matching prototype DOM)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'السفراء',
                          style: GoogleFonts.alexandria(
                            color: ColorManager.paper100,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'أصوات بتساعد الحكايات تلاقي طريقها. تعرف عليهم وعلى دورهم.',
                          style: GoogleFonts.ibmPlexSansArabic(
                            color: ColorManager.paper200.withValues(alpha: 0.65),
                            fontSize: 13.sp,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Ambassadors Cards List
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 120.h),
                  sliver: SliverList.separated(
                    itemCount: state.ambassadors.length,
                    separatorBuilder: (context, index) => SizedBox(height: 16.h),
                    itemBuilder: (context, index) {
                      final item = state.ambassadors[index];
                      return AmbassadorCardItem(
                        ambassador: item,
                        onTap: () {
                          context.push(
                            Routes.ambassadorDetails,
                            extra: {'id': item.id},
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

