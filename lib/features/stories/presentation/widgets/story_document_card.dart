import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors_manager.dart';
import '../../../../core/theming/styles.dart';
import '../screens/document_viewer_screen.dart';

/// Card displayed on the story details screen when the story media is a document.
///
/// Features:
/// - Supports PDF natively via [DocumentViewerScreen].
/// - Supports Word (.docx, .doc) via high-speed in-app WebView (Office Viewer).
/// - Zero external CocoaPods or Native dependencies (100% Swift Package Manager compatible).
class StoryDocumentCard extends StatelessWidget {
  final String title;
  final String documentUrl;
  final String documentKey;

  const StoryDocumentCard({
    super.key,
    required this.title,
    required this.documentUrl,
    required this.documentKey,
  });

  bool get _isPdf {
    final cleanUrl = documentUrl.split('?').first.toLowerCase();
    return cleanUrl.endsWith('.pdf');
  }

  void _openDocument(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DocumentViewerScreen(
          title: title,
          documentUrl: documentUrl,
          documentKey: documentKey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPdf = _isPdf;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: ColorManager.primaryLight.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: ColorManager.gold.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: ColorManager.gold.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPdf
                      ? Icons.picture_as_pdf_rounded
                      : Icons.description_rounded,
                  color: ColorManager.gold,
                  size: 26.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'document.story_document'.tr(),
                      style: TextStyles.font12GoldBold,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.font14WhiteSemiBold.copyWith(
                        color: ColorManager.paper100,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 46.h,
            child: ElevatedButton.icon(
              onPressed: () => _openDocument(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.gold,
                foregroundColor: ColorManager.primaryDark,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              icon: Icon(Icons.menu_book_rounded, size: 20.sp),
              label: Text(
                'document.view_document'.tr(),
                style: TextStyles.font14PrimarySemiBold.copyWith(
                  color: ColorManager.primaryDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

