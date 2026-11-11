import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/helpers/arabic_to_english_digits_formatter.dart';
import 'package:hekayat_3al_raf/core/models/country_phone_info.dart';
import 'package:hekayat_3al_raf/core/routing/routes.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_cached_network_image.dart';
import 'package:hekayat_3al_raf/core/widgets/app_phone_input_field.dart';
import 'package:hekayat_3al_raf/core/widgets/app_snack_bar.dart';
import 'package:hekayat_3al_raf/features/auth/presentation/bloc/login_cubit.dart';
import 'package:hekayat_3al_raf/features/auth/presentation/bloc/login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => getIt<LoginCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  CountryPhoneInfo _selectedCountry = CountryPhoneInfo.defaultCountry;
  bool _obscurePassword = true;
  String? _loginError;
  String? _passwordError;

  bool get _isPhoneInput {
    final text = _loginController.text.trim();
    if (text.isEmpty) return false;
    final firstChar = text.characters.first;
    // Check if the first character is an ASCII digit or Arabic-Indic numeral
    return RegExp(r'^[0-9٠-٩۰-۹+]').hasMatch(firstChar);
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showCountryPicker(BuildContext context) {
    showCountryPickerSheet(
      context: context,
      selectedCountry: _selectedCountry,
      onSelected: (country) {
        setState(() {
          _selectedCountry = country;
          _loginError = null;
        });
      },
    );
  }

  bool _validateInputs() {
    setState(() {
      _loginError = null;
      _passwordError = null;
    });

    final lang = context.locale.languageCode;
    final text = _loginController.text.trim();
    final password = _passwordController.text.trim();
    bool isValid = true;

    if (text.isEmpty) {
      _loginError = lang == 'ar'
          ? 'يرجى إدخال رقم الموبايل أو البريد الإلكتروني'
          : 'Please enter your mobile or email';
      isValid = false;
    } else if (_isPhoneInput) {
      if (!_selectedCountry.isValid(text)) {
        _loginError = lang == 'ar'
            ? 'رقم هاتف غير صحيح لدولة ${_selectedCountry.nameAr} (مثال: ${_selectedCountry.exampleNumber})'
            : 'Invalid phone number for ${_selectedCountry.nameEn} (e.g. ${_selectedCountry.exampleNumber})';
        isValid = false;
      }
    } else {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(text)) {
        _loginError = lang == 'ar'
            ? 'صيغة البريد الإلكتروني غير صحيحة'
            : 'Invalid email address format';
        isValid = false;
      }
    }

    if (password.isEmpty) {
      _passwordError = lang == 'ar'
          ? 'يرجى إدخال كلمة المرور'
          : 'Please enter your password';
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  void _onLoginPressed() {
    if (!_validateInputs()) return;

    context.read<LoginCubit>().login(
      loginInput: _loginController.text,
      phoneRegion: _isPhoneInput ? _selectedCountry.code : 'EG',
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          AppSnackBar.showSuccess(context, message: 'auth.welcome_back'.tr());
          // Navigate to Home or Profile
          context.go(Routes.home);
        } else if (state is LoginFailure) {
          AppSnackBar.showError(context, message: state.errorMessage);
        }
      },
      child: Scaffold(
        backgroundColor: ColorManager.primaryDark,
        body: Stack(
          children: [
            // 1. Cinematic Background Image with Gradient Overlays
            Positioned.fill(
              child: AppCachedNetworkImage(
                imageUrl:
                    'https://hekayat-ala-el-raff-m9tr.bolt.host/home/hero-album.webp',
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.4),
                memCacheWidth: 750,
              ),
            ),
            // Gradient Overlay 1: Top to Bottom
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorManager.primaryDark.withValues(alpha: 0.80),
                      ColorManager.primaryDark.withValues(alpha: 0.88),
                      ColorManager.primaryDark,
                    ],
                  ),
                ),
              ),
            ),
            // Gradient Overlay 2: Bottom vignette
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      ColorManager.primaryDark,
                      Colors.transparent,
                      ColorManager.primaryDark.withValues(alpha: 0.60),
                    ],
                  ),
                ),
              ),
            ),

            // 2. Foreground Content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 24.h),

                      // Logo
                      AppCachedNetworkImage(
                        imageUrl:
                            'https://hekayat-ala-el-raff-m9tr.bolt.host/brand/logo-gold.webp',
                        height: 54.h,
                        fit: BoxFit.contain,
                        memCacheHeight: 140,
                        errorWidget: Text(
                          'حكايات على الرف',
                          style: AppFonts.arefRuqaa(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorManager.gold,
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),

                      // Welcome Title
                      Text(
                        'أهلاً بيكم تاني',
                        style: AppFonts.alexandria(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.paper100,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Subtitle
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 290.w),
                        child: Text(
                          'كل حكاية بتبدأ بحد بيفتح الباب. ادخل واكمل من حيث وقفت.',
                          textAlign: TextAlign.center,
                          style: AppFonts.ibmPlexSansArabic(
                            fontSize: 13.5.sp,
                            color: ColorManager.paper200.withValues(
                              alpha: 0.65,
                            ),
                            height: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Input 1: Phone / Email Login
                      _buildFieldLabel(
                        context.locale.languageCode == 'ar'
                            ? 'رقم الموبايل أو البريد الإلكتروني'
                            : 'Mobile Number or Email',
                      ),
                      _buildLoginField(),
                      if (_loginError != null)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h, right: 6.w, left: 6.w),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              _loginError!,
                              style: AppFonts.ibmPlexSansArabic(
                                fontSize: 11.sp,
                                color: ColorManager.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 16.h),

                      // Input 2: Password
                      _buildFieldLabel('auth.password'.tr()),
                      _buildPasswordField(),
                      if (_passwordError != null)
                        Padding(
                          padding: EdgeInsets.only(top: 4.h, right: 6.w, left: 6.w),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              _passwordError!,
                              style: AppFonts.ibmPlexSansArabic(
                                fontSize: 11.sp,
                                color: ColorManager.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: 8.h),

                      // Forgot Password Link
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            context.push(Routes.forgotPassword);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'auth.forgot_password'.tr(),
                            style: AppFonts.ibmPlexSansArabic(
                              fontSize: 12.sp,
                              color: ColorManager.goldLight.withValues(
                                alpha: 0.75,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Submit Login Button
                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          final isLoading = state is LoginLoading;

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: isLoading ? null : _onLoginPressed,
                              borderRadius: BorderRadius.circular(30.r),
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFE8CB7D),
                                      Color(0xFFC9A24B),
                                    ],
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
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                ColorManager.primaryDark,
                                              ),
                                        ),
                                      )
                                    else ...[
                                      Text(
                                        'تسجيل الدخول',
                                        style: AppFonts.alexandria(
                                          fontSize: 14.5.sp,
                                          fontWeight: FontWeight.bold,
                                          color: ColorManager.primaryDark,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Icon(
                                        Icons.chevron_left_rounded,
                                        size: 18.sp,
                                        color: ColorManager.primaryDark,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // Divider (أو)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: ColorManager.gold.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Text(
                                'أو',
                                style: AppFonts.ibmPlexSansArabic(
                                  fontSize: 11.5.sp,
                                  color: ColorManager.paper400,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: ColorManager.gold.withValues(
                                  alpha: 0.15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Guest Entry Button
                      OutlinedButton(
                        onPressed: () => context.go(Routes.home),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.infinity, 48.h),
                          side: BorderSide(
                            color: ColorManager.paper100.withValues(
                              alpha: 0.25,
                            ),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Text(
                          'الدخول كزائر',
                          style: AppFonts.ibmPlexSansArabic(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w500,
                            color: ColorManager.paper100,
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ماعندكش حساب؟ ',
                            style: AppFonts.ibmPlexSansArabic(
                              fontSize: 13.sp,
                              color: ColorManager.paper300,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.pushReplacement(Routes.register);
                            },
                            child: Text(
                              'أنشئ حساب',
                              style: AppFonts.alexandria(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorManager.gold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 36.h),

                      // Footer Note
                      Text(
                        'حكايات على الرف · نسخة تجريبية للعرض',
                        style: AppFonts.ibmPlexSansArabic(
                          fontSize: 10.5.sp,
                          color: ColorManager.paper400.withValues(alpha: 0.5),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: EdgeInsets.only(bottom: 6.h),
        child: Text(
          label,
          style: AppFonts.ibmPlexSansArabic(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: ColorManager.paper300,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginField() {
    final lang = context.locale.languageCode;
    final isPhone = _isPhoneInput;
    final hasError = _loginError != null;

    return Container(
      decoration: BoxDecoration(
        color: ColorManager.primary.withValues(alpha: 0.50),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: hasError
              ? ColorManager.error
              : ColorManager.gold.withValues(alpha: 0.15),
          width: hasError ? 1.4 : 1,
        ),
      ),
      child: Row(
        children: [
          // If first input character is a digit -> show interactive country selector
          if (isPhone)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showCountryPicker(context),
                borderRadius: BorderRadius.horizontal(
                  right: lang == 'ar' ? Radius.circular(10.r) : Radius.zero,
                  left: lang != 'ar' ? Radius.circular(10.r) : Radius.zero,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: lang == 'ar'
                          ? BorderSide(
                              color: ColorManager.gold.withValues(alpha: 0.15),
                              width: 1,
                            )
                          : BorderSide.none,
                      right: lang != 'ar'
                          ? BorderSide(
                              color: ColorManager.gold.withValues(alpha: 0.15),
                              width: 1,
                            )
                          : BorderSide.none,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _selectedCountry.flag,
                        style: TextStyle(fontSize: 18.sp),
                      ),
                      SizedBox(width: 4.w),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 80.w),
                        child: Text(
                          _selectedCountry.localizedName(lang),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppFonts.ibmPlexSansArabic(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorManager.paper100,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '(${_selectedCountry.dialCode})',
                        textDirection: TextDirection.ltr,
                        style: AppFonts.ibmPlexSansArabic(
                          fontSize: 11.sp,
                          color: ColorManager.gold,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Icon(
                        CupertinoIcons.chevron_down,
                        size: 11.sp,
                        color: ColorManager.paper400.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Icon(
                CupertinoIcons.mail,
                color: ColorManager.gold.withValues(alpha: 0.50),
                size: 18.sp,
              ),
            ),

          // Input field
          Expanded(
            child: TextField(
              controller: _loginController,
              keyboardType: isPhone ? TextInputType.phone : TextInputType.emailAddress,
              inputFormatters: [
                const ArabicToEnglishDigitsFormatter(),
                if (isPhone)
                  LengthLimitingTextInputFormatter(
                    _selectedCountry.maxLength + 6,
                  ),
              ],
              textDirection: TextDirection.ltr,
              onChanged: (val) {
                // If user pastes/enters '+' or dial code prefix (e.g. +966..., 0020...)
                if (val.startsWith('+') || val.startsWith('00')) {
                  final detected = CountryPhoneInfo.findByLeadingDialCode(val);
                  if (detected != null) {
                    final normalized = detected.normalizeNumber(val);
                    setState(() {
                      _selectedCountry = detected;
                      _loginController.value = TextEditingValue(
                        text: normalized,
                        selection: TextSelection.collapsed(offset: normalized.length),
                      );
                      if (_loginError != null) _loginError = null;
                    });
                    return;
                  }
                }

                setState(() {
                  if (_loginError != null) _loginError = null;
                });
              },
              style: AppFonts.ibmPlexSansArabic(
                color: ColorManager.paper100,
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                hintText: isPhone
                    ? _selectedCountry.exampleNumber
                    : (lang == 'ar' ? '01012345678 أو name@example.com' : '01012345678 or name@example.com'),
                hintTextDirection: TextDirection.ltr,
                hintStyle: AppFonts.ibmPlexSansArabic(
                  color: ColorManager.paper400.withValues(alpha: 0.5),
                  fontSize: 12.5.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 13.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.primary.withValues(alpha: 0.50),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: ColorManager.gold.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _passwordController,
        obscureText: _obscurePassword,
        textDirection: TextDirection.ltr,
        style: AppFonts.ibmPlexSansArabic(
          color: ColorManager.paper100,
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            CupertinoIcons.lock,
            color: ColorManager.gold.withValues(alpha: 0.50),
            size: 18.sp,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
              color: ColorManager.paper400.withValues(alpha: 0.7),
              size: 18.sp,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          hintText: '••••••••',
          hintStyle: AppFonts.ibmPlexSansArabic(
            color: ColorManager.paper400.withValues(alpha: 0.6),
            fontSize: 13.5.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 13.h,
          ),
        ),
      ),
    );
  }
}
