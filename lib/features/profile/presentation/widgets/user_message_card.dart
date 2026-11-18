import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/user_message_entity.dart';

class UserMessageCard extends StatelessWidget {
  final UserMessageEntity message;

  const UserMessageCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isReplied = message.isReplied;
    final statusColor = isReplied ? const Color(0xFF10B981) : ColorManager.gold;

    return Container(
      decoration: BoxDecoration(
        color: ColorManager.primaryLight.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isReplied
              ? statusColor.withValues(alpha: 0.25)
              : ColorManager.gold.withValues(alpha: 0.15),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Subject + Status Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  message.subject.isNotEmpty
                      ? message.subject
                      : 'contact.subject'.tr(),
                  style: AppFonts.alexandria(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.paper100,
                    height: 1.3,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: statusColor.withValues(alpha: 0.4),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isReplied
                          ? CupertinoIcons.checkmark_circle_fill
                          : CupertinoIcons.clock_fill,
                      size: 12.sp,
                      color: statusColor,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      message.statusLabel.isNotEmpty
                          ? message.statusLabel
                          : (isReplied
                              ? 'profile.my_messages_screen.stat_replied'.tr()
                              : 'profile.my_messages_screen.stat_pending'.tr()),
                      style: AppFonts.ibmPlexSansArabic(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          // User's original message
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: ColorManager.primaryDark.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: ColorManager.gold.withValues(alpha: 0.08),
              ),
            ),
            child: Text(
              message.message,
              style: AppFonts.ibmPlexSansArabic(
                fontSize: 13.sp,
                color: ColorManager.paper200,
                height: 1.45,
              ),
            ),
          ),

          // Admin Reply Section (if available)
          if (isReplied && message.reply != null && message.reply!.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          CupertinoIcons.reply_thick_solid,
                          size: 14,
                          color: Color(0xFF10B981),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          'profile.my_messages_screen.admin_reply'.tr(),
                          style: AppFonts.alexandria(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      message.reply!,
                      style: AppFonts.ibmPlexSansArabic(
                        fontSize: 13.sp,
                        color: ColorManager.paper100,
                        height: 1.45,
                      ),
                    ),
                    if (message.repliedAt != null) ...[
                      SizedBox(height: 6.h),
                      Text(
                        'profile.my_messages_screen.replied_at'.tr(args: [
                          DateFormat('yyyy/MM/dd - hh:mm a').format(message.repliedAt!),
                        ]),
                        style: AppFonts.ibmPlexSansArabic(
                          fontSize: 10.5.sp,
                          color: ColorManager.paper400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

          if (!isReplied) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  CupertinoIcons.info_circle,
                  size: 13.sp,
                  color: ColorManager.paper400,
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    'profile.my_messages_screen.no_reply_yet'.tr(),
                    style: AppFonts.ibmPlexSansArabic(
                      fontSize: 11.5.sp,
                      color: ColorManager.paper400,
                    ),
                  ),
                ),
              ],
            ),
          ],

          // Footer: Timestamp
          if (message.created != null) ...[
            SizedBox(height: 10.h),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                DateFormat('yyyy/MM/dd - hh:mm a').format(message.created!),
                style: AppFonts.ibmPlexSansArabic(
                  fontSize: 10.5.sp,
                  color: ColorManager.paper400.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
