import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/core/theming/font_manager.dart';

/// Centralized Text Styles for "حكايات على الرف".
///
/// Organized cleanly by typography role:
/// 1. Heritage Calligraphy (Aref Ruqaa) for branding & literary headers
/// 2. Headings & Titles (Alexandria) for screens & section titles
/// 3. Body & Descriptions (IBM Plex Sans Arabic) for stories & reading
/// 4. UI Controls & Buttons (IBM Plex Sans Arabic / Alexandria)
class TextStyles {
  TextStyles._();

  // ===========================================================================
  // 1. Heritage & Branding Typography (Aref Ruqaa)
  // ===========================================================================

  static TextStyle font28PrimaryHeritage = AppFonts.arefRuqaa(
    fontSize: 28.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.primary,
  );

  static TextStyle font24PrimaryHeritage = AppFonts.arefRuqaa(
    fontSize: 24.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.primary,
  );

  static TextStyle font22GoldHeritage = AppFonts.arefRuqaa(
    fontSize: 22.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.gold,
  );

  static TextStyle font18GoldHeritage = AppFonts.arefRuqaa(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.gold,
  );

  // ===========================================================================
  // 2. Headings & Section Titles (Alexandria)
  // ===========================================================================

  static TextStyle font22PrimaryBold = AppFonts.alexandria(
    fontSize: 22.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.primary,
  );

  static TextStyle font20PrimaryBold = AppFonts.alexandria(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.primary,
  );

  static TextStyle font20WhiteBold = AppFonts.alexandria(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.bold,
    color: Colors.white,
  );

  static TextStyle font18PrimaryBold = AppFonts.alexandria(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.primary,
  );

  static TextStyle font18WhiteBold = AppFonts.alexandria(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.bold,
    color: Colors.white,
  );

  static TextStyle font16PrimarySemiBold = AppFonts.alexandria(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorManager.primary,
  );

  static TextStyle font16WhiteBold = AppFonts.alexandria(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.bold,
    color: Colors.white,
  );

  static TextStyle font16WhiteSemiBold = AppFonts.alexandria(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.white,
  );

  static TextStyle font15WhiteBold = AppFonts.alexandria(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.bold,
    color: Colors.white,
  );

  static TextStyle font14PrimarySemiBold = AppFonts.alexandria(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorManager.primary,
  );

  static TextStyle font14GoldMedium = AppFonts.alexandria(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorManager.gold,
  );

  static TextStyle font14WhiteSemiBold = AppFonts.alexandria(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.white,
  );

  static TextStyle font12WhiteBold = AppFonts.alexandria(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.bold,
    color: Colors.white,
  );

  static TextStyle font12GoldBold = AppFonts.alexandria(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.gold,
  );

  static TextStyle font12PrimaryBold = AppFonts.alexandria(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.primary,
  );

  // ===========================================================================
  // 3. Body, Reading & Details (IBM Plex Sans Arabic)
  // ===========================================================================

  static TextStyle font16TextMedium = AppFonts.ibmPlexSansArabic(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorManager.textLight,
  );

  static TextStyle font16TextRegular = AppFonts.ibmPlexSansArabic(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textLight,
    height: 1.6,
  );

  static TextStyle font15WhiteMedium = AppFonts.ibmPlexSansArabic(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );

  static TextStyle font15TextRegular = AppFonts.ibmPlexSansArabic(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textLight,
    height: 1.5,
  );

  static TextStyle font14TextMedium = AppFonts.ibmPlexSansArabic(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorManager.textLight,
  );

  static TextStyle font14TextRegular = AppFonts.ibmPlexSansArabic(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textLight,
  );

  static TextStyle font14WhiteMedium = AppFonts.ibmPlexSansArabic(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );

  static TextStyle font14MutedRegular = AppFonts.ibmPlexSansArabic(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textMutedLight,
  );

  static TextStyle font13MutedRegular = AppFonts.ibmPlexSansArabic(
    fontSize: 13.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textMutedLight,
  );

  static TextStyle font12MutedRegular = AppFonts.ibmPlexSansArabic(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textMutedLight,
  );

  static TextStyle font12TextRegular = AppFonts.ibmPlexSansArabic(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textLight,
  );

  static TextStyle font10MutedRegular = AppFonts.ibmPlexSansArabic(
    fontSize: 10.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textMutedLight,
  );
}
