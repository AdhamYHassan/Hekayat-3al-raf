import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/widgets/app_snack_bar.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/routing/routes.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/contact/presentation/bloc/contact_us_cubit.dart';
import 'package:hekayat_3al_raf/features/contact/presentation/bloc/contact_us_state.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ContactUsCubit>(
      create: (context) => getIt<ContactUsCubit>(),
      child: const _ContactUsView(),
    );
  }
}

class _ContactUsView extends StatefulWidget {
  const _ContactUsView();

  @override
  State<_ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<_ContactUsView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String _selectedSubject = '';

  final List<Map<String, String>> _subjects = const [
    {'value': 'general', 'label': 'استفسار عام'},
    {'value': 'submission', 'label': 'سؤال عن إرسال حكاية'},
    {'value': 'ambassadors', 'label': 'السفراء'},
    {'value': 'collaboration', 'label': 'التعاون'},
    {'value': 'other', 'label': 'حاجة تانية'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    context.read<ContactUsCubit>().submitMessage(
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          subject: _selectedSubject,
          message: _messageController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactUsCubit, ContactUsState>(
      listener: (context, state) {
        if (state is ContactUsSuccess) {
          AppSnackBar.showSuccess(
            context,
            message: state.message,
          );
          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _messageController.clear();
          setState(() {
            _selectedSubject = '';
          });
        } else if (state is ContactUsFailure) {
          AppSnackBar.showError(
            context,
            message: state.errorMessage,
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorManager.primaryDark,
        appBar: AppBar(
          backgroundColor: ColorManager.primaryDark,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          titleSpacing: 16.w,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                'https://hekayat-ala-el-raff-m9tr.bolt.host/brand/logo-gold.webp',
                height: 32.h,
                errorBuilder: (context, error, stackTrace) => Text(
                  'حكايات على الرف',
                  style: GoogleFonts.arefRuqaa(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorManager.gold,
                  ),
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(20.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'رجوع',
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorManager.goldLight,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        CupertinoIcons.arrow_left,
                        size: 14.sp,
                        color: ColorManager.goldLight,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.h),
            child: Container(
              color: ColorManager.gold.withValues(alpha: 0.15),
              height: 1.h,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

                // 1. Title & Subtitle
                Text(
                  'تواصل معنا',
                  style: GoogleFonts.alexandria(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.paper100,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'سؤال، اقتراح، أو فكرة تعاون. اكتبلنا وإحنا هنقرا كل كلمة.',
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 13.sp,
                    color: ColorManager.paper200.withValues(alpha: 0.60),
                    height: 1.5,
                  ),
                ),

                SizedBox(height: 20.h),

                // 2. Quick Action Cards (احكي حكايتك / السفراء)
                _buildQuickCard(
                  title: 'عايز تحكي حكاية؟ مش محتاج تكلمنا الأول.',
                  actionText: 'احكي حكايتك',
                  onTap: () {
                    Navigator.of(context).pop();
                    // Go to Submit Tab or Route
                    context.push(Routes.submitStoryForm);
                  },
                ),
                SizedBox(height: 8.h),
                _buildQuickCard(
                  title: 'عايز تعرف السفراء بيعملوا إيه؟',
                  actionText: 'السفراء',
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),

                SizedBox(height: 20.h),

                // 3. Contact Form
                // Full Name
                _buildFieldLabel('الاسم بالكامل'),
                _buildTextField(
                  controller: _nameController,
                  hintText: 'الاسم بالكامل',
                ),
                SizedBox(height: 14.h),

                // Email
                _buildFieldLabel('البريد الإلكتروني'),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'email@example.com',
                  keyboardType: TextInputType.emailAddress,
                  textDirection: TextDirection.ltr,
                ),
                SizedBox(height: 14.h),

                // Phone
                _buildFieldLabel('رقم الموبايل (اختياري)'),
                _buildTextField(
                  controller: _phoneController,
                  hintText: '+20...',
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                ),
                SizedBox(height: 14.h),

                // Subject Dropdown
                _buildFieldLabel('الموضوع'),
                _buildSubjectDropdown(),
                SizedBox(height: 14.h),

                // Message Textarea
                _buildFieldLabel('رسالتك'),
                _buildTextField(
                  controller: _messageController,
                  hintText: 'رسالتك',
                  maxLines: 5,
                ),
                SizedBox(height: 24.h),

                // Submit Button
                BlocBuilder<ContactUsCubit, ContactUsState>(
                  builder: (context, state) {
                    final isSubmitting = state is ContactUsSubmitting;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: isSubmitting ? null : _submit,
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
                              if (isSubmitting)
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
                                  'ابعت الرسالة',
                                  style: GoogleFonts.alexandria(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: ColorManager.primaryDark,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  CupertinoIcons.paperplane_fill,
                                  size: 16.sp,
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

                SizedBox(height: 60.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        label,
        style: GoogleFonts.ibmPlexSansArabic(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: ColorManager.paper300,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    TextDirection? textDirection,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.primaryLight.withValues(alpha: 0.40),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: ColorManager.gold.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textDirection: textDirection,
        style: GoogleFonts.ibmPlexSansArabic(
          color: ColorManager.paper100,
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.ibmPlexSansArabic(
            color: ColorManager.paper400.withValues(alpha: 0.6),
            fontSize: 13.5.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildSubjectDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: ColorManager.primaryLight.withValues(alpha: 0.40),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: ColorManager.gold.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSubject.isEmpty ? null : _selectedSubject,
          hint: Text(
            'اختار موضوع',
            style: GoogleFonts.ibmPlexSansArabic(
              color: ColorManager.paper400.withValues(alpha: 0.6),
              fontSize: 13.5.sp,
            ),
          ),
          dropdownColor: ColorManager.primaryDark,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: ColorManager.gold.withValues(alpha: 0.6),
          ),
          items: _subjects.map((item) {
            return DropdownMenuItem<String>(
              value: item['value'],
              child: Text(
                item['label']!,
                style: GoogleFonts.ibmPlexSansArabic(
                  color: ColorManager.paper100,
                  fontSize: 13.5.sp,
                ),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              setState(() {
                _selectedSubject = val;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildQuickCard({
    required String title,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: ColorManager.primaryLight.withValues(alpha: 0.20),
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: ColorManager.gold.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.ibmPlexSansArabic(
                  color: ColorManager.paper200.withValues(alpha: 0.60),
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                actionText,
                style: GoogleFonts.ibmPlexSansArabic(
                  color: ColorManager.gold,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

