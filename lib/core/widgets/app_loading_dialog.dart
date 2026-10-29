import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:base_app/core/theming/colors_manager.dart';
import 'package:base_app/core/theming/styles.dart';
import 'package:base_app/core/widgets/app_loading_indicator.dart';

class AppLoadingDialog {
  static bool _isShowing = false;

  /// Displays the theme-aware loading dialog.
  /// It prevents user interaction by being non-dismissible and blocking Android's back button.
  static void show(BuildContext context) {
    if (_isShowing) return;
    _isShowing = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
                decoration: BoxDecoration(
                  color: ColorManager.getCard(context),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: ColorManager.getBorder(context),
                    width: 1.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 15.r,
                      spreadRadius: 2.r,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppLoadingIndicator(size: 55),
                    SizedBox(height: 16.h),
                    Text(
                      "loading".tr(),
                      style: TextStyles.font15WhiteBold.copyWith(
                        color: ColorManager.getText(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      _isShowing = false;
    });
  }

  /// Dismisses the loading dialog if it is currently displayed.
  static void hide(BuildContext context) {
    if (!_isShowing) return;
    Navigator.of(context, rootNavigator: true).pop();
  }
}
