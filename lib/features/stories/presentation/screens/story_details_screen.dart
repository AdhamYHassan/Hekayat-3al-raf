import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hekayat_3al_raf/core/theming/colors_manager.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/widgets/story_detail_header.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/widgets/story_media_hero.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/widgets/story_player_card.dart';
import 'package:hekayat_3al_raf/features/stories/presentation/widgets/story_rating_section.dart';

class StoryDetailsScreen extends StatelessWidget {
  const StoryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryDark,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Bar with Brand Logo and Back button
            StoryDetailHeader(onBackTap: () => Navigator.of(context).pop()),
            // 2. Scrollable Body
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(bottom: 40.h),
                children: [
                  // Hero Cover & Header info
                  StoryMediaHero(
                    imageUrl:
                        'https://hekayat-ala-el-raff-m9tr.bolt.host/home/hero-album.webp',
                    title: 'الألبوم اللي فضل في الدولاب أربعين سنة',
                    authorInfo: 'فتحي عبد الله · القاهرة',
                    category: 'ذكريات',
                    year: '١٩٨٤',
                    mediaType: StoryMediaType.audio,
                    onShareTap: () {},
                  ),
                  // Stats bar
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.eye,
                              size: 14.sp,
                              color: ColorManager.paper400,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '٤٨٫٢ ألف',
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 12.sp,
                                color: ColorManager.paper200,
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Icon(
                              CupertinoIcons.star_fill,
                              size: 14.sp,
                              color: ColorManager.gold,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '٤٫٦',
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 12.sp,
                                color: ColorManager.paper200,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '٢١ سبتمبر',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 11.sp,
                            color: ColorManager.paper400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: ColorManager.gold.withValues(alpha: 0.15),
                    height: 1.h,
                  ),

                  // Article intro paragraph
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 8.h),
                    child: Text(
                      'عم فتحي ماكانش بيفتح الألبوم ده قدام حد. لما حفيدته سألته عن الصورة اللي في الصفحة الأخيرة، سكت شوية... وبعدين ابتدى يحكي عن صيف سنة ١٩٨٤.',
                      style: GoogleFonts.ibmPlexSansArabic(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorManager.goldLight.withValues(alpha: 0.95),
                        height: 1.9,
                      ),
                    ),
                  ),

                  // Media / Voice Note Player Container (Audio / Video / Image)
                  const StoryPlayerCard(
                    mediaType: StoryMediaType.audio,
                    title: 'الألبوم اللي فضل في الدولاب أربعين سنة',
                    narrator: 'فتحي عبد الله · القاهرة',
                    category: 'ذكريات ١٩٨٤',
                    artworkUrl:
                        'https://hekayat-ala-el-raff-m9tr.bolt.host/home/hero-album.webp',
                    audioUrl: 'https://server7.mp3quran.net/basit/001.mp3',
                  ),

                  // Narrative body paragraphs
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الحكاية دي اتسجلت في صالة بيت عم فتحي في شبرا، والشباك مفتوح على صوت الشارع. حفيدته مريم هي اللي ضغطت زرار التسجيل، وهو اللي قرر يكمل.',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 14.sp,
                            color: ColorManager.paper200.withValues(alpha: 0.8),
                            height: 1.9,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'بيحكي عن بيت ماعادش موجود، وعن جيران كانوا بيتقاسموا الشاي على السلم، وعن صورة واحدة فضلت مستخبية في آخر صفحة لأنها كانت أصعب من إنها تتشاف.',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 14.sp,
                            color: ColorManager.paper200.withValues(alpha: 0.8),
                            height: 1.9,
                          ),
                        ),
                        // Literary Pull Quote
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20.h),
                          padding: EdgeInsets.only(
                            right: 14.w,
                            left: 8.w,
                            top: 4.h,
                            bottom: 4.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: ColorManager.gold,
                                width: 2.5.w,
                              ),
                            ),
                          ),
                          child: Text(
                            '«أنا مش بحكي عشان افتكر... أنا بحكي عشان ماحدش ينساهم.»',
                            style: GoogleFonts.arefRuqaa(
                              fontSize: 18.sp,
                              color: ColorManager.goldLight,
                              height: 1.6,
                            ),
                          ),
                        ),
                        Text(
                          'التسجيل كامل زي ما اتقال، من غير تعديل غير إننا شيلنا أصوات الموبايل اللي رن مرتين في النص.',
                          style: GoogleFonts.ibmPlexSansArabic(
                            fontSize: 14.sp,
                            color: ColorManager.paper200.withValues(alpha: 0.8),
                            height: 1.9,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),
                  // Rating Section
                  const StoryRatingSection(),

                  // Share Button
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(24.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            color: ColorManager.gold.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.share,
                              size: 16.sp,
                              color: ColorManager.gold,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'مشاركة',
                              style: GoogleFonts.ibmPlexSansArabic(
                                fontSize: 13.sp,
                                color: ColorManager.gold,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Ambassador Attached Card
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: ColorManager.primaryLight.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: ColorManager.gold.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24.r),
                            child: Image.network(
                              'https://hekayat-ala-el-raff-m9tr.bolt.host/amb-2.webp',
                              width: 48.w,
                              height: 48.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'السفير المرافق',
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 10.sp,
                                    color: ColorManager.goldLight,
                                  ),
                                ),
                                Text(
                                  'أحمد رشدي',
                                  style: GoogleFonts.alexandria(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: ColorManager.paper100,
                                  ),
                                ),
                                Text(
                                  'إذاعي سابق',
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    fontSize: 10.sp,
                                    color: ColorManager.paper400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            CupertinoIcons.chevron_back,
                            size: 18.sp,
                            color: ColorManager.gold,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Related Stories (حكايات تانية)
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 12.h),
                    child: Text(
                      'حكايات تانية',
                      style: GoogleFonts.alexandria(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorManager.paper100,
                      ),
                    ),
                  ),
                  _buildRelatedStoryItem(
                    'الصور اللي ستي خبتها في علبة البسكويت',
                    'ندى الشريف',
                    'https://hekayat-ala-el-raff-m9tr.bolt.host/home/feature-tin.webp',
                  ),
                  _buildRelatedStoryItem(
                    'شريط كاسيت من أبويا وهو في الغربة',
                    'محمود عبد الرحيم',
                    'https://hekayat-ala-el-raff-m9tr.bolt.host/home/hero-abroad.webp',
                  ),
                  _buildRelatedStoryItem(
                    'جواب ماتبعتش',
                    'سلوى منير',
                    'https://hekayat-ala-el-raff-m9tr.bolt.host/home/feature-letter.webp',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedStoryItem(String title, String author, String imageUrl) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              imageUrl,
              width: 64.w,
              height: 64.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.alexandria(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorManager.paper100,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  author,
                  style: GoogleFonts.ibmPlexSansArabic(
                    fontSize: 10.sp,
                    color: ColorManager.paper400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
