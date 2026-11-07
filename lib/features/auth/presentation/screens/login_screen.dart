import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:hekayat_3al_raf/core/widgets/app_snack_bar.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/routing/routes.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
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
  bool _obscurePassword = true;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    context.read<LoginCubit>().login(
          loginInput: _loginController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          AppSnackBar.showSuccess(
            context,
            message: 'auth.welcome_back'.tr(),
          );
          // Navigate to Home or Profile
          context.go(Routes.home);
        } else if (state is LoginFailure) {
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
            // 1. Cinematic Background Image with Gradient Overlays
            Positioned.fill(
              child: Image.network(
                'https://hekayat-ala-el-raff-m9tr.bolt.host/home/hero-album.webp',
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.4),
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: ColorManager.primaryDark),
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
                      Image.network(
                        'https://hekayat-ala-el-raff-m9tr.bolt.host/brand/logo-gold.webp',
                        height: 54.h,
                        errorBuilder: (context, error, stackTrace) => Text(
                          'حكايات على الرف',
                          style: GoogleFonts.arefRuqaa(
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
                        style: GoogleFonts.alexandria(
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
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 13.5.sp,
                            color: ColorManager.paper200.withValues(alpha: 0.65),
                            height: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 32.h),

                      // Input 1: Phone / Login
                      _buildFieldLabel('رقم الموبايل'),
                      _buildLoginField(),
                      SizedBox(height: 16.h),

                      // Input 2: Password
                      _buildFieldLabel('كلمة المرور'),
                      _buildPasswordField(),
                      SizedBox(height: 8.h),

                      // Forgot Password Link
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            // Forgot Password Action
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'نسيت كلمة المرور؟',
                            style: GoogleFonts.ibmPlexSansArabic(
                              fontSize: 12.sp,
                              color: ColorManager.goldLight.withValues(alpha: 0.75),
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

                      // Divider (أو)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: ColorManager.gold.withValues(alpha: 0.15),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Text(
                                'أو',
                                style: GoogleFonts.ibmPlexSansArabic(
                                  fontSize: 11.5.sp,
                                  color: ColorManager.paper400,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: ColorManager.gold.withValues(alpha: 0.15),
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
                            color: ColorManager.paper100.withValues(alpha: 0.25),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        child: Text(
                          'الدخول كزائر',
                          style: GoogleFonts.ibmPlexSansArabic(
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
                            style: GoogleFonts.ibmPlexSansArabic(
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
                              style: GoogleFonts.alexandria(
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

  Widget _buildLoginField() {
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
        controller: _loginController,
        keyboardType: TextInputType.phone,
        textDirection: TextDirection.ltr,
        style: GoogleFonts.ibmPlexSansArabic(
          color: ColorManager.paper100,
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            CupertinoIcons.phone,
            color: ColorManager.gold.withValues(alpha: 0.50),
            size: 18.sp,
          ),
          hintText: '01XXXXXXXXX',
          hintStyle: GoogleFonts.ibmPlexSansArabic(
            color: ColorManager.paper400.withValues(alpha: 0.6),
            fontSize: 13.5.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        ),
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
        style: GoogleFonts.ibmPlexSansArabic(
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
          hintText: '••••••••',
          hintStyle: GoogleFonts.ibmPlexSansArabic(
            color: ColorManager.paper400.withValues(alpha: 0.6),
            fontSize: 13.5.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        ),
      ),
    );
  }
}

