import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_back_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AppWebViewScreen extends StatefulWidget {
  final String title;
  final String initialUrl;

  const AppWebViewScreen({
    super.key,
    required this.title,
    required this.initialUrl,
  });

  @override
  State<AppWebViewScreen> createState() => _AppWebViewScreenState();
}

class _AppWebViewScreenState extends State<AppWebViewScreen> {
  late final WebViewController _controller;
  int _loadingProgress = 0;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(ColorManager.primaryDark)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) {
              setState(() {
                _loadingProgress = progress;
              });
            }
          },
          onPageStarted: (url) {
            if (mounted) {
              setState(() {
                _hasError = false;
                _loadingProgress = 10;
              });
            }
          },
          onPageFinished: (url) {
            if (mounted) {
              setState(() {
                _loadingProgress = 100;
              });
            }
          },
          onWebResourceError: (error) {
            if (mounted) {
              setState(() {
                _hasError = true;
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final titleWidget = Expanded(
      child: Text(
        widget.title,
        style: AppFonts.alexandria(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          color: ColorManager.paper100,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
    const backWidget = AppBackButton();

    return Scaffold(
      backgroundColor: ColorManager.primaryDark,
      appBar: AppBar(
        backgroundColor: ColorManager.primaryDark,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        titleSpacing: 16.w,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: isArabic
              ? [titleWidget, SizedBox(width: 8.w), backWidget]
              : [backWidget, SizedBox(width: 8.w), titleWidget],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.h),
          child: _loadingProgress < 100 && !_hasError
              ? LinearProgressIndicator(
                  value: _loadingProgress / 100.0,
                  backgroundColor: ColorManager.primaryLight.withValues(alpha: 0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(ColorManager.gold),
                  minHeight: 2.h,
                )
              : const SizedBox.shrink(),
        ),
      ),
      body: _hasError
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.wifi_exclamationmark,
                      color: ColorManager.gold,
                      size: 48.sp,
                    ),
                    SizedBox(height: 14.h),
                    Text(
                      'errors.no_internet_connection'.tr(),
                      textAlign: TextAlign.center,
                      style: AppFonts.ibmPlexSansArabic(
                        fontSize: 14.sp,
                        color: ColorManager.paper200,
                      ),
                    ),
                    SizedBox(height: 18.h),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _hasError = false;
                          _loadingProgress = 10;
                        });
                        _controller.reload();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.gold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 10.h,
                        ),
                      ),
                      icon: Icon(
                        CupertinoIcons.refresh,
                        color: ColorManager.primaryDark,
                        size: 16.sp,
                      ),
                      label: Text(
                        'common.retry'.tr(),
                        style: AppFonts.alexandria(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : WebViewWidget(controller: _controller),
    );
  }
}

