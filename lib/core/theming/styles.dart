import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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

  static TextStyle font28PrimaryHeritage = GoogleFonts.arefRuqaa(
    fontSize: 28.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.primary,
  );

  static TextStyle font24PrimaryHeritage = GoogleFonts.arefRuqaa(
    fontSize: 24.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.primary,
  );

  static TextStyle font22GoldHeritage = GoogleFonts.arefRuqaa(
    fontSize: 22.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.gold,
  );

  static TextStyle font18GoldHeritage = GoogleFonts.arefRuqaa(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.gold,
  );

  // ===========================================================================
  // 2. Headings & Section Titles (Alexandria)
  // ===========================================================================

  static TextStyle font22PrimaryBold = GoogleFonts.alexandria(
    fontSize: 22.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.primary,
  );

  static TextStyle font20PrimaryBold = GoogleFonts.alexandria(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.primary,
  );

  static TextStyle font20WhiteBold = GoogleFonts.alexandria(
    fontSize: 20.sp,
    fontWeight: FontWeightHelper.bold,
    color: Colors.white,
  );

  static TextStyle font18PrimaryBold = GoogleFonts.alexandria(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.primary,
  );

  static TextStyle font18WhiteBold = GoogleFonts.alexandria(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.bold,
    color: Colors.white,
  );

  static TextStyle font16PrimarySemiBold = GoogleFonts.alexandria(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorManager.primary,
  );

  static TextStyle font16WhiteBold = GoogleFonts.alexandria(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.bold,
    color: Colors.white,
  );

  static TextStyle font16WhiteSemiBold = GoogleFonts.alexandria(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.white,
  );

  static TextStyle font15WhiteBold = GoogleFonts.alexandria(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.bold,
    color: Colors.white,
  );

  static TextStyle font14PrimarySemiBold = GoogleFonts.alexandria(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: ColorManager.primary,
  );

  static TextStyle font14GoldMedium = GoogleFonts.alexandria(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorManager.gold,
  );

  static TextStyle font14WhiteSemiBold = GoogleFonts.alexandria(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.white,
  );

  static TextStyle font12WhiteBold = GoogleFonts.alexandria(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.bold,
    color: Colors.white,
  );

  static TextStyle font12GoldBold = GoogleFonts.alexandria(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.gold,
  );

  static TextStyle font12PrimaryBold = GoogleFonts.alexandria(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorManager.primary,
  );

  // ===========================================================================
  // 3. Body, Reading & Details (IBM Plex Sans Arabic)
  // ===========================================================================

  static TextStyle font16TextMedium = GoogleFonts.ibmPlexSansArabic(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorManager.textLight,
  );

  static TextStyle font16TextRegular = GoogleFonts.ibmPlexSansArabic(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textLight,
    height: 1.6,
  );

  static TextStyle font15WhiteMedium = GoogleFonts.ibmPlexSansArabic(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );

  static TextStyle font15TextRegular = GoogleFonts.ibmPlexSansArabic(
    fontSize: 15.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textLight,
    height: 1.5,
  );

  static TextStyle font14TextMedium = GoogleFonts.ibmPlexSansArabic(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorManager.textLight,
  );

  static TextStyle font14TextRegular = GoogleFonts.ibmPlexSansArabic(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textLight,
  );

  static TextStyle font14WhiteMedium = GoogleFonts.ibmPlexSansArabic(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );

  static TextStyle font14MutedRegular = GoogleFonts.ibmPlexSansArabic(
    fontSize: 14.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textMutedLight,
  );

  static TextStyle font13MutedRegular = GoogleFonts.ibmPlexSansArabic(
    fontSize: 13.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textMutedLight,
  );

  static TextStyle font12MutedRegular = GoogleFonts.ibmPlexSansArabic(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textMutedLight,
  );

  static TextStyle font12TextRegular = GoogleFonts.ibmPlexSansArabic(
    fontSize: 12.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textLight,
  );

  static TextStyle font10MutedRegular = GoogleFonts.ibmPlexSansArabic(
    fontSize: 10.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorManager.textMutedLight,
  );
}
