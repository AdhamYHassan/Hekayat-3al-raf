import 'package:hekayat_3al_raf/features/home/data/datasources/i_home_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_extra_entities.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_hero_slide.dart';
import 'package:hekayat_3al_raf/features/home/domain/entities/home_story_entity.dart';

/// Accurate Mock Data Source using the EXACT URLs, titles, and text from the HTML DOM.
class HomeMockDataSource implements IHomeRemoteDataSource {
  static const String _baseUrl = 'https://hekayat-ala-el-raff-m9tr.bolt.host';

  @override
  Future<List<HomeHeroSlide>> getHeroSlides() async {
    return const [
      HomeHeroSlide(
        id: 'hero-1',
        subtitle: 'حكايات على الرف',
        title: 'كل حكاية تستحق إنها تتسمع.',
        description: 'مكان بتلاقي فيه حكايات من كل أنحاء العالم العربي صوتها، وناسها، ولحظتها.',
        imageUrl: '$_baseUrl/home/hero-collage.webp',
        ctaLabel: 'اكتشف الحكايات',
        secondaryCtaLabel: 'احكي حكايتك',
      ),
      HomeHeroSlide(
        id: 'hero-2',
        subtitle: 'حكايات على الرف',
        title: 'ألبوم العائلة وذكريات الزمن الجميل.',
        description: 'مكان بتلاقي فيه حكايات من كل أنحاء العالم العربي صوتها، وناسها، ولحظتها.',
        imageUrl: '$_baseUrl/home/hero-album.webp',
        ctaLabel: 'اكتشف الحكايات',
        secondaryCtaLabel: 'احكي حكايتك',
      ),
      HomeHeroSlide(
        id: 'hero-3',
        subtitle: 'حكايات على الرف',
        title: 'أصوات الغربة والتسجيلات النادرة.',
        description: 'مكان بتلاقي فيه حكايات من كل أنحاء العالم العربي صوتها، وناسها، ولحظتها.',
        imageUrl: '$_baseUrl/home/hero-abroad.webp',
        ctaLabel: 'اكتشف الحكايات',
        secondaryCtaLabel: 'احكي حكايتك',
      ),
      HomeHeroSlide(
        id: 'hero-4',
        subtitle: 'حكايات على الرف',
        title: 'أول خطوة وأول حلم في شوارعنا.',
        description: 'مكان بتلاقي فيه حكايات من كل أنحاء العالم العربي صوتها، وناسها، ولحظتها.',
        imageUrl: '$_baseUrl/home/hero-bike.webp',
        ctaLabel: 'اكتشف الحكايات',
        secondaryCtaLabel: 'احكي حكايتك',
      ),
    ];
  }

  @override
  Future<FeaturedStoryEntity> getFeaturedStory() async {
    return const FeaturedStoryEntity(
      story: StoryFeedItem(
        id: 'album-in-the-closet',
        title: 'الألبوم اللي فضل في الدولاب أربعين سنة',
        category: 'عيلة وذكريات',
        excerpt: 'عم فتحي ماكانش بيفتح الألبوم ده قدام حد. لما حفيدته سألته عن الصورة اللي في الصفحة الأخيرة، سكت شوية... وبعدين ابتدى يحكي عن صيف سنة ١٩٨٤، وعن بيت في شبرا ماعادش موجود، وعن ناس لسه فاكر ضحكتهم.',
        authorName: 'فتحي عبد الله',
        coverImageUrl: '$_baseUrl/featured-story.webp',
        contentType: StoryContentType.audio,
        viewsCount: 48200,
        rating: 4.6,
      ),
      pullQuote: 'أنا مش بحكي عشان افتكر... أنا بحكي عشان ماحدش ينساهم.',
    );
  }

  @override
  Future<List<StoryFeedItem>> getTopStories() async {
    return const [
      StoryFeedItem(
        id: 'album-in-the-closet',
        title: 'الألبوم اللي فضل في الدولاب أربعين سنة',
        category: 'عيلة وذكريات',
        excerpt: 'صوتيات مسجلة من شبرا سنة ١٩٨٤.',
        authorName: 'فتحي عبد الله',
        coverImageUrl: '$_baseUrl/home/hero-album.webp',
        contentType: StoryContentType.audio,
        viewsCount: 48200,
        rating: 4.6,
      ),
      StoryFeedItem(
        id: 'photos-in-the-biscuit-tin',
        title: 'الصور اللي ستي خبتها في علبة البسكويت',
        category: 'ذكريات',
        excerpt: 'حكاية مكتوبة عن صور عائلية نادرة.',
        authorName: 'نادية منصور',
        coverImageUrl: '$_baseUrl/home/feature-tin.webp',
        contentType: StoryContentType.text,
        viewsCount: 9400,
        rating: 4.7,
      ),
      StoryFeedItem(
        id: 'cassette-from-abroad',
        title: 'شريط كاسيت من أبويا وهو في الغربة',
        category: 'رسائل صوتية',
        excerpt: 'تسجيل نادر عبر شريط كاسيت من السبعينات.',
        authorName: 'طارق كمال',
        coverImageUrl: '$_baseUrl/home/hero-abroad.webp',
        contentType: StoryContentType.audio,
        viewsCount: 7800,
        rating: 4.8,
      ),
      StoryFeedItem(
        id: 'letter-never-sent',
        title: 'جواب ماتبعتش',
        category: 'رسائل',
        excerpt: 'رسالة قديمة وُجدت بين طيات كتاب عتيق.',
        authorName: 'مريم خليل',
        coverImageUrl: '$_baseUrl/home/feature-letter.webp',
        contentType: StoryContentType.text,
        viewsCount: 27300,
        rating: 4.4,
      ),
      StoryFeedItem(
        id: 'corniche-before-it-changed',
        title: 'الكورنيش قبل ما يتغير',
        category: 'أماكن وتاريخ',
        excerpt: 'فيديو وذكريات مصورة عن كورنيش النيل زمان.',
        authorName: 'هشام عزت',
        coverImageUrl: '$_baseUrl/home/feature-corniche.webp',
        contentType: StoryContentType.video,
        viewsCount: 15200,
        rating: 4.3,
      ),
      StoryFeedItem(
        id: 'grandmothers-recipe-book',
        title: 'دفتر وصفات جدتي',
        category: 'وثائق',
        excerpt: 'وثيقة بخط اليد لوصفات ونكهات البيوت القديمة.',
        authorName: 'منى الشافعي',
        coverImageUrl: '$_baseUrl/home/card-recipe.webp',
        contentType: StoryContentType.text,
        viewsCount: 5100,
        rating: 4.7,
      ),
      StoryFeedItem(
        id: 'first-bicycle',
        title: 'أول عجلة... وآخر مرة أبويا جري ورايا',
        category: 'طفولة',
        excerpt: 'ذكريات دافئة عن شوارع زمان وبداية الاعتماد على النفس.',
        authorName: 'خالد سليم',
        coverImageUrl: '$_baseUrl/home/hero-bike.webp',
        contentType: StoryContentType.text,
        viewsCount: 18600,
        rating: 4.2,
      ),
      StoryFeedItem(
        id: 'the-workshop-key',
        title: 'مفتاح الورشة',
        category: 'حرف ومهن',
        excerpt: 'تسجيل صوتي مع أقدم صانع مفاتيح في حي العتبة.',
        authorName: 'عم محروس',
        coverImageUrl: '$_baseUrl/home/card-workshop.webp',
        contentType: StoryContentType.audio,
        viewsCount: 3200,
        rating: 4.9,
      ),
    ];
  }

  @override
  Future<List<AmbassadorFeedItem>> getAmbassadors() async {
    return const [
      AmbassadorFeedItem(
        id: 'mona-elhusseiny',
        name: 'منى الحسيني',
        role: 'كاتبة وروائية',
        portraitUrl: '$_baseUrl/amb-1.webp',
      ),
      AmbassadorFeedItem(
        id: 'ahmed-roshdy',
        name: 'أحمد رشدي',
        role: 'إذاعي سابق',
        portraitUrl: '$_baseUrl/amb-2.webp',
      ),
      AmbassadorFeedItem(
        id: 'yasmine-fouad',
        name: 'ياسمين فؤاد',
        role: 'مخرجة أفلام وثائقية',
        portraitUrl: '$_baseUrl/amb-3.webp',
      ),
      AmbassadorFeedItem(
        id: 'omar-eldessouky',
        name: 'عمر الدسوقي',
        role: 'باحث في التاريخ الشفهي',
        portraitUrl: '$_baseUrl/amb-4.webp',
      ),
      AmbassadorFeedItem(
        id: 'hagga-zeinab',
        name: 'الحاجة زينب',
        role: 'حكّاءة',
        portraitUrl: '$_baseUrl/amb-5.webp',
      ),
    ];
  }

  @override
  Future<List<RegionArchiveItem>> getRegions() async {
    return const [
      RegionArchiveItem(
        id: 'egypt',
        name: 'مصر',
        citiesSummary: 'القاهرة · الإسكندرية · الصعيد · الدلتا',
        tagline: 'حواري بتفتكر، وبيوت لسه بتحكي.',
        photoUrl: '$_baseUrl/home/region-egypt.webp',
      ),
      RegionArchiveItem(
        id: 'gulf',
        name: 'الخليج العربي',
        citiesSummary: 'السعودية · الإمارات · الكويت · قطر',
        tagline: 'مجالس بتجمع الأجيال على فنجان وحكاية.',
        photoUrl: '$_baseUrl/home/region-gulf.webp',
      ),
      RegionArchiveItem(
        id: 'north-africa',
        name: 'شمال أفريقيا',
        citiesSummary: 'المغرب · الجزائر · تونس · ليبيا',
        tagline: 'أبواب زرقا، ووشوش بتحلم بكرة.',
        photoUrl: '$_baseUrl/home/region-maghreb.webp',
      ),
      RegionArchiveItem(
        id: 'levant',
        name: 'بلاد الشام',
        citiesSummary: 'سوريا · لبنان · فلسطين · الأردن',
        tagline: 'بلكونات مليانة زرع، وحضن بيستنى.',
        photoUrl: '$_baseUrl/home/region-levant.webp',
      ),
      RegionArchiveItem(
        id: 'sudan',
        name: 'السودان',
        citiesSummary: 'الخرطوم · أم درمان · كسلا · دارفور',
        tagline: 'صبر طويل، وذاكرة أطول من النيل.',
        photoUrl: '$_baseUrl/home/region-sudan.webp',
      ),
    ];
  }
}
