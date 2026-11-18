import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hekayat_3al_raf/core/routing/routes.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_back_button.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/user_message_entity.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/bloc/my_messages_cubit.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/bloc/my_messages_state.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/widgets/my_messages_shimmer_loading.dart';
import 'package:hekayat_3al_raf/features/profile/presentation/widgets/user_message_card.dart';

class MyMessagesScreen extends StatefulWidget {
  const MyMessagesScreen({super.key});

  @override
  State<MyMessagesScreen> createState() => _MyMessagesScreenState();
}

class _MyMessagesScreenState extends State<MyMessagesScreen> {
  int _selectedFilterIndex = 0; // 0: All, 1: Replied, 2: Pending

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryDark,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            // Top App Bar
            _buildAppBar(context),

            // Content
            Expanded(
              child: BlocBuilder<MyMessagesCubit, MyMessagesState>(
                builder: (context, state) {
                  return switch (state) {
                    MyMessagesInitial() || MyMessagesLoading() =>
                      const SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: MyMessagesShimmerLoading(),
                      ),
                    MyMessagesError(:final message) => Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.r),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                CupertinoIcons.exclamationmark_circle,
                                color: ColorManager.gold,
                                size: 48.sp,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                message,
                                textAlign: TextAlign.center,
                                style: AppFonts.ibmPlexSansArabic(
                                  color: ColorManager.paper200,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 16.h),
                              ElevatedButton(
                                onPressed: () => context
                                    .read<MyMessagesCubit>()
                                    .loadMyMessages(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorManager.gold,
                                  foregroundColor: ColorManager.primaryDark,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                ),
                                child: Text('common.retry'.tr()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    MyMessagesLoaded(:final messages) => RefreshIndicator(
                        onRefresh: () =>
                            context.read<MyMessagesCubit>().loadMyMessages(),
                        color: ColorManager.gold,
                        backgroundColor: ColorManager.primary,
                        child: _buildMessagesList(context, state, messages),
                      ),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: ColorManager.primaryDark,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        bottom: 12.h,
        left: 16.w,
        right: 16.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AppBackButton(
                onTap: () => context.pop(),
                color: ColorManager.gold,
              ),
              SizedBox(width: 4.w),
              Text(
                'profile.my_messages_screen.back_to_profile'.tr(),
                style: AppFonts.ibmPlexSansArabic(
                  fontSize: 13.sp,
                  color: ColorManager.gold,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () => context.push(Routes.contactUs),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.gold,
              foregroundColor: ColorManager.primaryDark,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            icon: const Icon(CupertinoIcons.paperplane_fill, size: 14),
            label: Text(
              'profile.my_messages_screen.send_message'.tr(),
              style: AppFonts.alexandria(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: ColorManager.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(
    BuildContext context,
    MyMessagesLoaded state,
    List<UserMessageEntity> messages,
  ) {
    final filteredMessages = switch (_selectedFilterIndex) {
      1 => messages.where((m) => m.isReplied).toList(),
      2 => messages.where((m) => !m.isReplied).toList(),
      _ => messages,
    };

    return ListView(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 8.h,
        bottom: 40.h,
      ),
      children: [
        // Kicker line & title
        Row(
          children: [
            Container(
              width: 20.w,
              height: 2.h,
              color: ColorManager.gold,
            ),
            SizedBox(width: 8.w),
            Text(
              'profile.my_messages_screen.kicker'.tr(),
              style: AppFonts.ibmPlexSansArabic(
                color: ColorManager.gold,
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          'profile.my_messages_screen.title'.tr(),
          style: AppFonts.alexandria(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: ColorManager.paper100,
          ),
        ),
        SizedBox(height: 16.h),

        // 3 Filter / Stat counters
        Row(
          children: [
            Expanded(
              child: _buildStatTab(
                label: 'profile.my_messages_screen.stat_all'.tr(),
                count: state.totalCount,
                isSelected: _selectedFilterIndex == 0,
                onTap: () => setState(() => _selectedFilterIndex = 0),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildStatTab(
                label: 'profile.my_messages_screen.stat_replied'.tr(),
                count: state.repliedCount,
                isSelected: _selectedFilterIndex == 1,
                onTap: () => setState(() => _selectedFilterIndex = 1),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildStatTab(
                label: 'profile.my_messages_screen.stat_pending'.tr(),
                count: state.pendingCount,
                isSelected: _selectedFilterIndex == 2,
                onTap: () => setState(() => _selectedFilterIndex = 2),
              ),
            ),
          ],
        ),

        SizedBox(height: 20.h),

        // List / Empty State
        if (filteredMessages.isEmpty)
          _buildEmptyState(context)
        else
          ...filteredMessages.map(
            (msg) => Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: UserMessageCard(message: msg),
            ),
          ),
      ],
    );
  }

  Widget _buildStatTab({
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorManager.primaryLight
              : ColorManager.primaryLight.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? ColorManager.gold
                : ColorManager.gold.withValues(alpha: 0.12),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: AppFonts.alexandria(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? ColorManager.gold : ColorManager.paper200,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: AppFonts.ibmPlexSansArabic(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? ColorManager.paper100 : ColorManager.paper400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 24.h),
      padding: EdgeInsets.all(28.r),
      decoration: BoxDecoration(
        color: ColorManager.primaryLight.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ColorManager.gold.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              color: ColorManager.gold.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.chat_bubble_2_fill,
              color: ColorManager.gold,
              size: 28.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'profile.my_messages_screen.empty_title'.tr(),
            style: AppFonts.alexandria(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.paper100,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'profile.my_messages_screen.empty_subtitle'.tr(),
            textAlign: TextAlign.center,
            style: AppFonts.ibmPlexSansArabic(
              fontSize: 12.5.sp,
              color: ColorManager.paper400,
              height: 1.5,
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton.icon(
            onPressed: () => context.push(Routes.contactUs),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.gold,
              foregroundColor: ColorManager.primaryDark,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            icon: const Icon(CupertinoIcons.pencil_outline, size: 16),
            label: Text(
              'profile.my_messages_screen.send_message'.tr(),
              style: AppFonts.alexandria(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: ColorManager.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
