import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';
import 'package:hekayat_3al_raf/core/widgets/app_back_button.dart';
import 'package:hekayat_3al_raf/core/widgets/app_snack_bar.dart';
import 'package:hekayat_3al_raf/core/di/dependency_injection.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/main/presentation/bloc/main_cubit.dart';
import 'package:hekayat_3al_raf/features/main/presentation/bloc/main_state.dart';
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
    {'value': 'general', 'labelKey': 'contact.subjects.inquiry'},
    {'value': 'suggestion', 'labelKey': 'contact.subjects.suggestion'},
    {'value': 'collaboration', 'labelKey': 'contact.subjects.partnership'},
    {'value': 'technical', 'labelKey': 'contact.subjects.technical'},
    {'value': 'other', 'labelKey': 'contact.subjects.other'},
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
          title: Builder(
            builder: (context) {
              final isArabic = context.locale.languageCode == 'ar';
              final logoWidget = Image.asset(
                'assets/images/applogo.png',
                height: 32.h,
                fit: BoxFit.contain,
                cacheHeight: (32 * 2.5).toInt(),
                filterQuality: FilterQuality.medium,
                errorBuilder: (context, error, stackTrace) => Text(
                  'app_name'.tr(),
                  style: AppFonts.arefRuqaa(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorManager.gold,
                  ),
                ),
              );
              const backWidget = AppBackButton();

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: isArabic
                    ? [logoWidget, backWidget]
                    : [backWidget, logoWidget],
              );
            },
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
                  'contact.title'.tr(),
                  style: AppFonts.alexandria(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.paper100,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'contact.subtitle'.tr(),
                  style: AppFonts.ibmPlexSansArabic(
                    fontSize: 13.sp,
                    color: ColorManager.paper200.withValues(alpha: 0.60),
                    height: 1.5,
                  ),
                ),

                SizedBox(height: 20.h),

                // 2. Quick Action Card (احكي حكايتك)
                _buildQuickCard(
                  title: 'contact.quick_submit_hint'.tr(),
                  actionText: 'contact.quick_submit_action'.tr(),
                  onTap: () {
                    Navigator.of(context).pop();
                    getIt<MainCubit>().changeTab(MainTab.submit);
                  },
                ),

                SizedBox(height: 20.h),

                // 3. Contact Form
                // Full Name
                _buildFieldLabel('contact.full_name'.tr()),
                _buildTextField(
                  controller: _nameController,
                  hintText: 'contact.full_name'.tr(),
                ),
                SizedBox(height: 14.h),

                // Email
                _buildFieldLabel('contact.email'.tr()),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'email@example.com',
                  keyboardType: TextInputType.emailAddress,
                  textDirection: TextDirection.ltr,
                ),
                SizedBox(height: 14.h),

                // Phone
                _buildFieldLabel('contact.phone'.tr()),
                _buildTextField(
                  controller: _phoneController,
                  hintText: '+20...',
                  keyboardType: TextInputType.phone,
                  textDirection: TextDirection.ltr,
                ),
                SizedBox(height: 14.h),

                // Subject Dropdown
                _buildFieldLabel('contact.subject'.tr()),
                _buildSubjectDropdown(),
                SizedBox(height: 14.h),

                // Message Textarea
                _buildFieldLabel('contact.message'.tr()),
                _buildTextField(
                  controller: _messageController,
                  hintText: 'contact.message'.tr(),
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
                                  'contact.send_button'.tr(),
                                  style: AppFonts.alexandria(
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
        style: AppFonts.ibmPlexSansArabic(
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
        style: AppFonts.ibmPlexSansArabic(
          color: ColorManager.paper100,
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppFonts.ibmPlexSansArabic(
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
            'contact.choose_subject'.tr(),
            style: AppFonts.ibmPlexSansArabic(
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
                item['labelKey']!.tr(),
                style: AppFonts.ibmPlexSansArabic(
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
                style: AppFonts.ibmPlexSansArabic(
                  color: ColorManager.paper200.withValues(alpha: 0.60),
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                actionText,
                style: AppFonts.ibmPlexSansArabic(
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

