import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';

class DeleteAccountDialog extends StatefulWidget {
  final Future<bool> Function(String password) onConfirmDelete;

  const DeleteAccountDialog({
    super.key,
    required this.onConfirmDelete,
  });

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleDelete() async {
    final password = _passwordController.text.trim();
    if (password.isEmpty) {
      setState(() {
        _errorMessage = 'settings.enter_password_to_delete'.tr();
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final success = await widget.onConfirmDelete(password);
    if (!mounted) return;

    if (!success) {
      setState(() {
        _isLoading = false;
      });
    } else {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(22.r),
        decoration: BoxDecoration(
          color: ColorManager.primaryDark,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: ColorManager.error.withValues(alpha: 0.4),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Warning Icon
            Center(
              child: Container(
                width: 54.r,
                height: 54.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorManager.error.withValues(alpha: 0.15),
                  border: Border.all(
                    color: ColorManager.error.withValues(alpha: 0.35),
                  ),
                ),
                child: Icon(
                  CupertinoIcons.trash_fill,
                  color: ColorManager.error,
                  size: 26.sp,
                ),
              ),
            ),
            SizedBox(height: 14.h),

            // Title
            Text(
              'settings.delete_account'.tr(),
              style: AppFonts.alexandria(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: ColorManager.paper100,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),

            // Warning Description
            Text(
              'settings.delete_account_warning'.tr(),
              style: AppFonts.ibmPlexSansArabic(
                fontSize: 12.sp,
                color: ColorManager.paper300.withValues(alpha: 0.85),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 18.h),

            // Password Field
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textDirection: TextDirection.ltr,
              style: AppFonts.ibmPlexSansArabic(
                fontSize: 13.5.sp,
                color: ColorManager.paper100,
              ),
              decoration: InputDecoration(
                hintText: 'auth.password'.tr(),
                hintTextDirection: TextDirection.rtl,
                hintStyle: AppFonts.ibmPlexSansArabic(
                  fontSize: 12.sp,
                  color: ColorManager.paper400.withValues(alpha: 0.5),
                ),
                prefixIcon: Icon(
                  CupertinoIcons.lock,
                  color: ColorManager.gold.withValues(alpha: 0.6),
                  size: 18.sp,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? CupertinoIcons.eye_slash
                        : CupertinoIcons.eye,
                    color: ColorManager.paper400.withValues(alpha: 0.6),
                    size: 18.sp,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                filled: true,
                fillColor: ColorManager.primaryLight.withValues(alpha: 0.3),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: _errorMessage != null
                        ? ColorManager.error
                        : ColorManager.gold.withValues(alpha: 0.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: _errorMessage != null
                        ? ColorManager.error
                        : ColorManager.gold.withValues(alpha: 0.2),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: _errorMessage != null
                        ? ColorManager.error
                        : ColorManager.gold,
                    width: 1.2,
                  ),
                ),
              ),
            ),

            if (_errorMessage != null) ...[
              SizedBox(height: 6.h),
              Text(
                _errorMessage!,
                style: AppFonts.ibmPlexSansArabic(
                  fontSize: 11.sp,
                  color: ColorManager.error,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
            ],

            SizedBox(height: 22.h),

            // Actions: Delete Confirm & Cancel
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 11.h),
                      side: BorderSide(
                        color: ColorManager.paper400.withValues(alpha: 0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'common.cancel'.tr(),
                      style: AppFonts.ibmPlexSansArabic(
                        fontSize: 13.sp,
                        color: ColorManager.paper300,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleDelete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.error,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 11.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 18.r,
                            height: 18.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'common.delete'.tr(),
                            style: AppFonts.alexandria(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
