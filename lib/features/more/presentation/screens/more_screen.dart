import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/helpers/secure_storage_helper.dart';
import 'package:hekayat_3al_raf/core/routing/routes.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/more/presentation/widgets/more_language_selector.dart';
import 'package:hekayat_3al_raf/features/more/presentation/widgets/more_menu_item_card.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;

    return Scaffold(
      backgroundColor: ColorManager.primaryDark,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 16.h),

              // 1. Logo & App Info Branding Header
              Center(
                child: Column(
                  children: [
                    Image.network(
                      'https://hekayat-ala-el-raff-m9tr.bolt.host/brand/logo-gold.webp',
                      height: 48.h,
                      errorBuilder: (context, error, stackTrace) => Text(
                        'حكايات على الرف',
                        style: GoogleFonts.arefRuqaa(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorManager.gold,
                        ),
                      ),
                    ),

                    SizedBox(height: 6.h),
                    Text(
                      'Advice Media Solutions',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 12.sp,
                        color: ColorManager.paper400,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // 2. Section: القائمة
              _buildSectionHeader('settings.menu_section'.tr()),
              SizedBox(height: 8.h),

              // Card 1: الملف الشخصي (Highlighted)
              MoreMenuItemCard(
                icon: CupertinoIcons.person_fill,
                title: 'settings.profile'.tr(),
                subtitle: 'settings.profile_sub'.tr(),
                isHighlighted: true,
                onTap: () async {
                  final token = await SecureStorageHelper.getToken();
                  if (context.mounted) {
                    if (token == null || token.trim().isEmpty) {
                      context.push(Routes.login);
                    } else {
                      context.push(Routes.profile);
                    }
                  }
                },
              ),
              SizedBox(height: 8.h),

              // Card 2: عن المنصة
              MoreMenuItemCard(
                icon: CupertinoIcons.info_circle_fill,
                title: 'settings.about_us'.tr(),
                subtitle: 'settings.about_us_sub'.tr(),
                onTap: () {
                  final lang = context.locale.languageCode == 'en'
                      ? 'en'
                      : 'ar';
                  context.push(
                    Routes.webView,
                    extra: {
                      'title': 'settings.about_us'.tr(),
                      'url': 'https://hekayat3alraf.com/$lang/about/',
                    },
                  );
                },
              ),
              SizedBox(height: 8.h),

              // Card 3: تواصل معنا
              MoreMenuItemCard(
                icon: CupertinoIcons.mail_solid,
                title: 'settings.contact_us'.tr(),
                subtitle: 'settings.contact_us_sub'.tr(),
                onTap: () {
                  context.push(Routes.contactUs);
                },
              ),
              SizedBox(height: 8.h),

              // Card 4: سياسة الخصوصية
              MoreMenuItemCard(
                icon: CupertinoIcons.shield_fill,
                title: 'settings.privacy_policy'.tr(),
                subtitle: 'settings.privacy_policy_sub'.tr(),
                onTap: () {
                  final lang = context.locale.languageCode == 'en'
                      ? 'en'
                      : 'ar';
                  context.push(
                    Routes.webView,
                    extra: {
                      'title': 'settings.privacy_policy'.tr(),
                      'url': 'https://hekayat3alraf.com/$lang/privacy/',
                    },
                  );
                },
              ),
              SizedBox(height: 8.h),

              // Card 5: الشروط والأحكام
              MoreMenuItemCard(
                icon: CupertinoIcons.doc_text_fill,
                title: 'settings.terms_conditions'.tr(),
                subtitle: 'settings.terms_conditions_sub'.tr(),
                onTap: () {
                  final lang = context.locale.languageCode == 'en'
                      ? 'en'
                      : 'ar';
                  context.push(
                    Routes.webView,
                    extra: {
                      'title': 'settings.terms_conditions'.tr(),
                      'url': 'https://hekayat3alraf.com/$lang/terms/',
                    },
                  );
                },
              ),

              SizedBox(height: 24.h),

              // 3. Section: اللغة
              _buildSectionHeader('settings.language_section'.tr()),
              SizedBox(height: 8.h),
              MoreLanguageSelector(
                currentLocale: locale,
                onLocaleChanged: (newLang) {
                  context.setLocale(Locale(newLang));
                },
              ),

              SizedBox(height: 32.h),

              // 4. Footer Note
              Text(
                'settings.footer_version'.tr(),
                style: GoogleFonts.ibmPlexSansArabic(
                  fontSize: 10.5.sp,
                  color: ColorManager.paper400.withValues(alpha: 0.6),
                ),
              ),

              // Spacing for Floating Bottom Nav Bar
              SizedBox(height: 120.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(width: 20.w, height: 1.5.h, color: ColorManager.gold),
        SizedBox(width: 8.w),
        Text(
          title,
          style: GoogleFonts.ibmPlexSansArabic(
            color: ColorManager.gold,
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
