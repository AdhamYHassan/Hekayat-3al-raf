import 'package:hekayat_3al_raf/features/ambassadors/data/datasources/i_ambassador_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_details_entity.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_list_item_entity.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/paginated_ambassadors_entity.dart';

/// In-memory mock data source providing authentic cultural oral history content
/// strictly matching the prototype DOM (Mona El-Husseini profile).
class AmbassadorMockDataSource implements IAmbassadorRemoteDataSource {
  static const String _baseUrl = 'https://hekayat-ala-el-raff-m9tr.bolt.host';

  @override
  Future<PaginatedAmbassadorsEntity> getAmbassadorsList({
    int limit = 10,
    int offset = 0,
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));

    const list = [
      AmbassadorListItemEntity(
        id: 'mona-elhusseiny',
        name: 'منى الحسيني',
        shortDescription: 'كاتبة وروائية',
        description: 'بتصدق إن أصدق الحكايات هي اللي اتقالت في المطبخ، مش في الكتب.',
        imageUrl: '$_baseUrl/amb-1.webp',
        followersCount: 120,
      ),
      AmbassadorListItemEntity(
        id: 'ahmed-roshdy',
        name: 'أحمد رشدي',
        shortDescription: 'إذاعي سابق',
        description: 'تلاتين سنة ورا الميكروفون، ودلوقتي بيسمع حكايات الناس بدل ما يحكي.',
        imageUrl: '$_baseUrl/amb-2.webp',
        followersCount: 95,
      ),
      AmbassadorListItemEntity(
        id: 'yasmine-fouad',
        name: 'ياسمين فؤاد',
        shortDescription: 'مخرجة أفلام وثائقية',
        description: 'بتدور على اللحظة الصغيرة اللي بتخلي الحكاية تعيش.',
        imageUrl: '$_baseUrl/amb-3.webp',
        followersCount: 84,
      ),
      AmbassadorListItemEntity(
        id: 'omar-eldessouky',
        name: 'عمر الدسوقي',
        shortDescription: 'باحث في التاريخ الشفهي',
        description: 'شغله إنه يحفظ أصوات الناس قبل ما تضيع.',
        imageUrl: '$_baseUrl/amb-4.webp',
        followersCount: 110,
      ),
      AmbassadorListItemEntity(
        id: 'hagga-zeinab',
        name: 'الحاجة زينب',
        shortDescription: 'حكّاءة',
        description: 'تمانين سنة وكل يوم عندها حكاية جديدة عن الحارة.',
        imageUrl: '$_baseUrl/amb-5.webp',
        followersCount: 310,
      ),
    ];

    return PaginatedAmbassadorsEntity(
      count: list.length,
      hasMore: false,
      ambassadors: list,
    );
  }

  @override
  Future<AmbassadorDetailsEntity> getAmbassadorDetails(String ambassadorId) async {
    // Simulate low-latency realistic network delay
    await Future.delayed(const Duration(milliseconds: 150));

    return const AmbassadorDetailsEntity(
      id: 'mona-elhusseiny',
      name: 'منى الحسيني',
      shortDescription: 'كاتبة وروائية',
      description: 'بتجمع حكايات الستات في مصر من سنة ٢٠١٠ — مش الحكايات الكبيرة، الحكايات اليومية اللي بتعدي من غير ما حد ياخد باله منها: طقم الصيني اللي ماتفتحش، والجواب اللي فضل في الدرج أربعين سنة، والوصفة اللي ضاعت لما الجدة ماتت.',
      coverImageUrl: '$_baseUrl/amb-1.webp',
      followersCount: 120,
      answeredCount: 128,
      isFollowing: false,
      canManage: false,
      webUrl: 'https://hekayat3alraf.com/ar/ambassadors/mona-elhusseiny/',
      gallery: [
        AmbassadorGalleryItem(
          id: 'g1',
          imageUrl: '$_baseUrl/amb-1.webp',
          caption: 'منى في جلسة استماع بشارع المعز',
          year: '٢٠٢٤',
        ),
        AmbassadorGalleryItem(
          id: 'g2',
          imageUrl: '$_baseUrl/home/archive-cairo-street.webp',
          caption: 'شارع المعز - القاهرة الفاطمية',
          year: '٢٠٢٣',
        ),
        AmbassadorGalleryItem(
          id: 'g3',
          imageUrl: '$_baseUrl/mem-letter.webp',
          caption: 'جواب عثر عليه في أرشيف العائلة',
          year: '١٩٦٨',
        ),
        AmbassadorGalleryItem(
          id: 'g4',
          imageUrl: '$_baseUrl/mem-shelf.webp',
          caption: 'مكتبة التوثيق الشفاهي',
          year: '٢٠٢٥',
        ),
      ],
      questions: [
        AmbassadorQaItem(
          id: 'q1',
          authorName: 'ليلى حسن',
          city: 'الإسكندرية',
          timeAgo: 'من يومين',
          question: 'إزاي أقنع جدتي تحكيلي عن طفولتها من غير ما تحس إني بحقق معاها؟',
          answer: 'ابدئي بحاجة ملموسة: صورة قديمة، فنجان شاي، ريحة أكل كانت بتعمله. ماتسأليش أسئلة مباشرة زي "كنتي بتعملي إيه في الستينات؟" بل قولي "فاكرة الفستان دا؟"',
          isAnswered: true,
        ),
        AmbassadorQaItem(
          id: 'q2',
          authorName: 'خالد منصور',
          city: 'طنطا',
          timeAgo: 'من أسبوع',
          question: 'لو الحكاية فيها تفاصيل مؤلمة للعيلة، الأفضل تتوثق ولا تتساب؟',
          answer: 'التوثيق مش معناه النشر الفوري للجميع. سجّل الحكاية لحفظ الحقيقة أولاً، وقرار المشاركة يرجع لأصحابها في الوقت المناسب.',
          isAnswered: true,
        ),
        AmbassadorQaItem(
          id: 'q3',
          authorName: 'هدى سمير',
          city: 'المنصورة',
          timeAgo: 'من ٣ أسابيع',
          question: 'هل بتسجلي بالصوت الأول ولا بتكتبي على طول؟',
          answer: 'دايماً بالصوت الأول — نبرة الصوت وسكتات الكلام فيها نص الحكاية اللي الحبر مابيعرفش ينقله.',
          isAnswered: true,
        ),
      ],
    );
  }

  @override
  Future<AmbassadorQaItem> submitQuestion({
    required String ambassadorSlug,
    required String body,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return AmbassadorQaItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      authorName: 'مستخدم',
      city: '',
      timeAgo: 'الآن',
      question: body,
      isAnswered: false,
    );
  }

  @override
  Future<List<AmbassadorQaItem>> getAmbassadorQuestions(
      String ambassadorSlug) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [];
  }
}

