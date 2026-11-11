import 'dart:async';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_snack_bar.dart';
import 'package:hekayat_3al_raf/features/auth/presentation/bloc/reset_password_cubit.dart';
import 'package:hekayat_3al_raf/features/auth/presentation/bloc/reset_password_state.dart';
import 'package:hekayat_3al_raf/features/auth/presentation/widgets/six_digit_pin_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResetPasswordCubit>(
      create: (_) => getIt<ResetPasswordCubit>(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _otpCode = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int _currentStep = 1;

  Timer? _resendTimer;
  int _secondsRemaining = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() => _secondsRemaining = 60);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 1) {
        setState(() => _secondsRemaining--);
      } else {
        _resendTimer?.cancel();
        setState(() => _secondsRemaining = 0);
      }
    });
  }

  void _onRequestCode() {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      AppSnackBar.showError(context, message: 'validation.invalid_email'.tr());
      return;
    }
    context.read<ResetPasswordCubit>().requestResetCode(email);
  }

  void _onConfirmReset() {
    if (_otpCode.length < 6) {
      AppSnackBar.showError(context, message: 'auth.code_length_error'.tr());
      return;
    }

    final newPass = _passwordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (newPass.length < 6) {
      AppSnackBar.showError(context, message: 'auth.password_length_error'.tr());
      return;
    }

    if (newPass != confirmPass) {
      AppSnackBar.showError(context, message: 'auth.password_mismatch'.tr());
      return;
    }

    context.read<ResetPasswordCubit>().confirmPasswordReset(
          code: _otpCode,
          newPassword: newPass,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryDark,
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordCodeSent) {
            AppSnackBar.showSuccess(context, message: state.message);
            setState(() => _currentStep = 2);
            _startResendTimer();
          } else if (state is ResetPasswordSuccess) {
            AppSnackBar.showSuccess(
              context,
              message: state.message.isNotEmpty
                  ? state.message
                  : 'auth.reset_success'.tr(),
            );
            context.pop();
          } else if (state is ResetPasswordFailure) {
            AppSnackBar.showError(context, message: state.errorMessage);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Back Button Header
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: ColorManager.goldLight,
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Brand Icon / Badge
                  Center(
                    child: RepaintBoundary(
                      child: Container(
                        width: 76.r,
                        height: 76.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorManager.gold.withValues(alpha: 0.12),
                          border: Border.all(
                            color: ColorManager.gold.withValues(alpha: 0.35),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          _currentStep == 1
                              ? CupertinoIcons.lock_shield_fill
                              : CupertinoIcons.check_mark_circled_solid,
                          color: ColorManager.gold,
                          size: 38.sp,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Title & Subtitle
                  Text(
                    _currentStep == 1
                        ? 'auth.reset_password'.tr()
                        : 'auth.verify_code_title'.tr(),
                    textAlign: TextAlign.center,
                    style: AppFonts.alexandria(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.paper100,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    _currentStep == 1
                        ? 'auth.forgot_password_subtitle'.tr()
                        : 'auth.verify_code_subtitle'.tr(
                            args: [_emailController.text.trim()],
                          ),
                    textAlign: TextAlign.center,
                    style: AppFonts.ibmPlexSansArabic(
                      fontSize: 13.sp,
                      color: ColorManager.paper300,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Step 1 or Step 2 Layout
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: _currentStep == 1
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: _buildStep1(state),
                    secondChild: _buildStep2(state),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStep1(ResetPasswordState state) {
    final isLoading = state is ResetPasswordRequestLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildFieldLabel('auth.email'.tr()),
        SizedBox(height: 6.h),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: AppFonts.ibmPlexSansArabic(
            fontSize: 14.sp,
            color: ColorManager.paper100,
          ),
          decoration: _inputDecoration(
            hint: 'example@domain.com',
            prefixIcon: CupertinoIcons.mail_solid,
          ),
        ),
        SizedBox(height: 28.h),
        _buildSubmitButton(
          title: 'auth.send_reset_code'.tr(),
          isLoading: isLoading,
          onTap: _onRequestCode,
        ),
      ],
    );
  }

  Widget _buildStep2(ResetPasswordState state) {
    final isLoading = state is ResetPasswordConfirmLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 6-Digit PIN Field
        _buildFieldLabel('auth.enter_code'.tr()),
        SizedBox(height: 8.h),
        SixDigitPinField(
          onChanged: (code) => _otpCode = code,
          onCompleted: (code) => _otpCode = code,
        ),

        SizedBox(height: 12.h),

        // Resend Timer Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                setState(() => _currentStep = 1);
              },
              child: Text(
                'تغيير البريد الإلكتروني',
                style: AppFonts.ibmPlexSansArabic(
                  fontSize: 12.sp,
                  color: ColorManager.goldLight.withValues(alpha: 0.8),
                ),
              ),
            ),
            if (_secondsRemaining > 0)
              Text(
                'auth.resend_in'.tr(args: ['$_secondsRemaining']),
                style: AppFonts.ibmPlexSansArabic(
                  fontSize: 12.sp,
                  color: ColorManager.paper400,
                ),
              )
            else
              TextButton(
                onPressed: _onRequestCode,
                child: Text(
                  'auth.resend_code'.tr(),
                  style: AppFonts.ibmPlexSansArabic(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.gold,
                  ),
                ),
              ),
          ],
        ),

        SizedBox(height: 16.h),

        // New Password
        _buildFieldLabel('auth.new_password'.tr()),
        SizedBox(height: 6.h),
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: AppFonts.ibmPlexSansArabic(
            fontSize: 14.sp,
            color: ColorManager.paper100,
          ),
          decoration: _inputDecoration(
            hint: 'auth.new_password_hint'.tr(),
            prefixIcon: CupertinoIcons.lock_fill,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? CupertinoIcons.eye_slash
                    : CupertinoIcons.eye,
                color: ColorManager.paper400,
                size: 20.sp,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),

        SizedBox(height: 16.h),

        // Confirm New Password
        _buildFieldLabel('auth.confirm_new_password'.tr()),
        SizedBox(height: 6.h),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          style: AppFonts.ibmPlexSansArabic(
            fontSize: 14.sp,
            color: ColorManager.paper100,
          ),
          decoration: _inputDecoration(
            hint: 'auth.confirm_new_password_hint'.tr(),
            prefixIcon: CupertinoIcons.lock_fill,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? CupertinoIcons.eye_slash
                    : CupertinoIcons.eye,
                color: ColorManager.paper400,
                size: 20.sp,
              ),
              onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
          ),
        ),

        SizedBox(height: 28.h),

        // Confirm Button
        _buildSubmitButton(
          title: 'auth.confirm_reset_action'.tr(),
          isLoading: isLoading,
          onTap: _onConfirmReset,
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: AppFonts.ibmPlexSansArabic(
        fontSize: 12.5.sp,
        fontWeight: FontWeight.w600,
        color: ColorManager.paper200,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppFonts.ibmPlexSansArabic(
        fontSize: 13.sp,
        color: ColorManager.paper400,
      ),
      filled: true,
      fillColor: ColorManager.primaryLight.withValues(alpha: 0.45),
      prefixIcon: Icon(prefixIcon, color: ColorManager.gold, size: 20.sp),
      suffixIcon: suffixIcon,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorManager.gold.withValues(alpha: 0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: ColorManager.gold.withValues(alpha: 0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: ColorManager.gold, width: 1.5),
      ),
    );
  }

  Widget _buildSubmitButton({
    required String title,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return RepaintBoundary(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(30.r),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8CB7D), Color(0xFFC9A24B)],
              ),
              borderRadius: BorderRadius.circular(30.r),
            ),
            padding: EdgeInsets.symmetric(vertical: 13.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20.r,
                    height: 20.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ColorManager.primaryDark,
                      ),
                    ),
                  )
                else ...[
                  Text(
                    title,
                    style: AppFonts.alexandria(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.primaryDark,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.chevron_left_rounded,
                    color: ColorManager.primaryDark,
                    size: 20.sp,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

