import 'package:hekayat_3al_raf/core/helpers/arabic_to_english_digits_formatter.dart';
import 'package:hekayat_3al_raf/core/widgets/app_cached_network_image.dart';
import 'package:hekayat_3al_raf/core/widgets/app_snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/routing/routes.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/auth/presentation/bloc/register_cubit.dart';
import 'package:hekayat_3al_raf/features/auth/presentation/bloc/register_state.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (context) => getIt<RegisterCubit>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreedToTerms = false;

  // Validation Error Messages per field
  String? _nameError;
  String? _phoneError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _termsError;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    setState(() {
      _nameError = null;
      _phoneError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
      _termsError = null;
    });

    bool isValid = true;
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty) {
      _nameError = 'يرجى إدخال الاسم بالكامل';
      isValid = false;
    }

    if (phone.isEmpty) {
      _phoneError = 'يرجى إدخال رقم الموبايل';
      isValid = false;
    } else if (phone.length < 10) {
      _phoneError = 'يرجى إدخال رقم موبايل صحيح';
      isValid = false;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty) {
      _emailError = 'يرجى إدخال البريد الإلكتروني';
      isValid = false;
    } else if (!emailRegex.hasMatch(email)) {
      _emailError = 'صيغة البريد الإلكتروني غير صحيحة';
      isValid = false;
    }

    if (password.isEmpty) {
      _passwordError = 'يرجى إدخال كلمة المرور';
      isValid = false;
    } else if (password.length < 6) {
      _passwordError = 'كلمة المرور يجب ألا تقل عن 6 أحرف';
      isValid = false;
    }

    if (confirmPassword.isEmpty) {
      _confirmPasswordError = 'يرجى تأكيد كلمة المرور';
      isValid = false;
    } else if (confirmPassword != password) {
      _confirmPasswordError = 'كلمتا المرور غير متطابقتين';
      isValid = false;
    }

    if (!_agreedToTerms) {
      _termsError = 'يجب الموافقة على الشروط والأحكام وسياسة الخصوصية';
      isValid = false;
    }

    setState(() {});
    return isValid;
  }

  void _onRegisterPressed() {
    if (!_validateForm()) return;

    context.read<RegisterCubit>().register(
      name: _nameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      agreedToTerms: _agreedToTerms,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          AppSnackBar.showSuccess(
            context,
            message: state.response.message,
          );
          context.go(Routes.home);
        } else if (state is RegisterFailure) {
          AppSnackBar.showError(
            context,
            message: state.errorMessage,
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorManager.primaryDark,
        body: Stack(
          children: [
            // 1. Cinematic Background Image
            Positioned.fill(
              child: AppCachedNetworkImage(
                imageUrl: 'https://hekayat-ala-el-raff-m9tr.bolt.host/home/hero-collage.webp',
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.5),
                memCacheWidth: 750,
              ),
            ),
            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorManager.primaryDark.withValues(alpha: 0.85),
                      ColorManager.primaryDark.withValues(alpha: 0.90),
                      ColorManager.primaryDark,
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
                      SizedBox(height: 18.h),

                      // Logo
                      AppCachedNetworkImage(
                        imageUrl: 'https://hekayat-ala-el-raff-m9tr.bolt.host/brand/logo-gold.webp',
                        height: 48.h,
                        fit: BoxFit.contain,
                        memCacheHeight: 120,
                        errorWidget: Text(
                          'حكايات على الرف',
                          style: GoogleFonts.arefRuqaa(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorManager.gold,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Sub-badge: حساب جديد
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 20.w,
                            height: 1.5.h,
                            color: ColorManager.gold,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'حساب جديد',
                            style: GoogleFonts.ibmPlexSansArabic(
                              color: ColorManager.gold,
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Welcome Title
                      Text(
                        'احكي حكايتك من اليوم',
                        style: GoogleFonts.alexandria(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.paper100,
                        ),
                      ),
                      SizedBox(height: 6.h),

                      // Subtitle
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 290.w),
                        child: Text(
                          'أنشئ حسابك وابدأ تشارك حكاياتك مع الناس اللي عايزة تسمع.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 13.sp,
                            color: ColorManager.paper200.withValues(
                              alpha: 0.65,
                            ),
                            height: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // 1. Full Name
                      _buildFieldLabel('الاسم بالكامل'),
                      _buildCustomTextField(
                        controller: _nameController,
                        hintText: 'اكتب اسمك',
                        icon: CupertinoIcons.person,
                        errorMessage: _nameError,
                        onChanged: (_) {
                          if (_nameError != null) {
                            setState(() => _nameError = null);
                          }
                        },
                      ),
                      SizedBox(height: 14.h),

                      // 2. Phone
                      _buildFieldLabel('رقم الموبايل'),
                      _buildCustomTextField(
                        controller: _phoneController,
                        hintText: '01XXXXXXXXX',
                        icon: CupertinoIcons.phone,
                        keyboardType: TextInputType.phone,
                        textDirection: TextDirection.ltr,
                        errorMessage: _phoneError,
                        onChanged: (_) {
                          if (_phoneError != null) {
                            setState(() => _phoneError = null);
                          }
                        },
                      ),
                      SizedBox(height: 14.h),

                      // 3. Email
                      _buildFieldLabel('البريد الإلكتروني'),
                      _buildCustomTextField(
                        controller: _emailController,
                        hintText: 'name@example.com',
                        icon: CupertinoIcons.mail,
                        keyboardType: TextInputType.emailAddress,
                        textDirection: TextDirection.ltr,
                        errorMessage: _emailError,
                        onChanged: (_) {
                          if (_emailError != null) {
                            setState(() => _emailError = null);
                          }
                        },
                      ),
                      SizedBox(height: 14.h),

                      // 4. Password
                      _buildFieldLabel('كلمة المرور'),
                      _buildCustomTextField(
                        controller: _passwordController,
                        hintText: '••••••••',
                        icon: CupertinoIcons.lock,
                        obscureText: _obscurePassword,
                        textDirection: TextDirection.ltr,
                        errorMessage: _passwordError,
                        onChanged: (_) {
                          if (_passwordError != null) {
                            setState(() => _passwordError = null);
                          }
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? CupertinoIcons.eye_slash
                                : CupertinoIcons.eye,
                            color: ColorManager.paper400.withValues(alpha: 0.7),
                            size: 18.sp,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 14.h),

                      // 5. Confirm Password
                      _buildFieldLabel('تأكيد كلمة المرور'),
                      _buildCustomTextField(
                        controller: _confirmPasswordController,
                        hintText: '••••••••',
                        icon: CupertinoIcons.lock,
                        obscureText: _obscureConfirmPassword,
                        textDirection: TextDirection.ltr,
                        errorMessage: _confirmPasswordError,
                        onChanged: (_) {
                          if (_confirmPasswordError != null) {
                            setState(() => _confirmPasswordError = null);
                          }
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? CupertinoIcons.eye_slash
                                : CupertinoIcons.eye,
                            color: ColorManager.paper400.withValues(alpha: 0.7),
                            size: 18.sp,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 14.h),

                      // 6. Terms & Privacy Checkbox Card
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _agreedToTerms = !_agreedToTerms;
                                if (_agreedToTerms) {
                                  _termsError = null;
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: ColorManager.primary.withValues(
                                  alpha: 0.30,
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: _termsError != null
                                      ? ColorManager.error
                                      : ColorManager.gold.withValues(
                                          alpha: 0.08,
                                        ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.h),
                                    child: SizedBox(
                                      width: 18.r,
                                      height: 18.r,
                                      child: Checkbox(
                                        value: _agreedToTerms,
                                        activeColor: ColorManager.gold,
                                        checkColor: ColorManager.primaryDark,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            _agreedToTerms = val ?? false;
                                            if (_agreedToTerms) {
                                              _termsError = null;
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        text: 'أوافق على ',
                                        style: GoogleFonts.ibmPlexSansArabic(
                                          fontSize: 11.5.sp,
                                          color: ColorManager.paper200
                                              .withValues(alpha: 0.70),
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'الشروط والأحكام',
                                            style:
                                                GoogleFonts.ibmPlexSansArabic(
                                                  color: ColorManager.goldLight,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const TextSpan(text: ' و'),
                                          TextSpan(
                                            text: 'سياسة الخصوصية',
                                            style:
                                                GoogleFonts.ibmPlexSansArabic(
                                                  color: ColorManager.goldLight,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (_termsError != null)
                            Padding(
                              padding: EdgeInsets.only(top: 5.h, right: 8.w),
                              child: Text(
                                _termsError!,
                                style: GoogleFonts.ibmPlexSansArabic(
                                  color: ColorManager.error,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 20.h),

                      // Submit Register Button
                      BlocBuilder<RegisterCubit, RegisterState>(
                        builder: (context, state) {
                          final isLoading = state is RegisterLoading;

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: isLoading ? null : _onRegisterPressed,
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
                                        'إنشاء الحساب',
                                        style: GoogleFonts.alexandria(
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
                      SizedBox(height: 16.h),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'عندك حساب بالفعل؟ ',
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 13.sp,
                              color: ColorManager.paper300,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.pushReplacement(Routes.login);
                            },
                            child: Text(
                              'سجل دخولك',
                              style: GoogleFonts.alexandria(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorManager.gold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 32.h),

                      // Footer Note
                      Text(
                        'حكايات على الرف · نسخة تجريبية للعرض',
                        style: GoogleFonts.ibmPlexSansArabic(
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
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(bottom: 6.h),
        child: Text(
          label,
          style: GoogleFonts.ibmPlexSansArabic(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: ColorManager.paper300,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    TextDirection? textDirection,
    String? errorMessage,
    ValueChanged<String>? onChanged,
  }) {
    final hasError = errorMessage != null && errorMessage.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: ColorManager.primary.withValues(alpha: 0.50),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: hasError
                  ? ColorManager.error
                  : ColorManager.gold.withValues(alpha: 0.15),
              width: hasError ? 1.2 : 1,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: [
              if (keyboardType == TextInputType.phone ||
                  keyboardType == TextInputType.number)
                const ArabicToEnglishDigitsFormatter(),
            ],
            textDirection: textDirection,
            onChanged: onChanged,
            style: GoogleFonts.ibmPlexSansArabic(
              color: ColorManager.paper100,
              fontSize: 14.sp,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: hasError
                    ? ColorManager.error
                    : ColorManager.gold.withValues(alpha: 0.50),
                size: 18.sp,
              ),
              suffixIcon: suffixIcon,
              hintText: hintText,
              hintStyle: GoogleFonts.ibmPlexSansArabic(
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
        ),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(top: 5.h, right: 8.w),
            child: Text(
              errorMessage,
              style: GoogleFonts.ibmPlexSansArabic(
                color: ColorManager.error,
                fontSize: 11.sp,
              ),
            ),
          ),
      ],
    );
  }
}
