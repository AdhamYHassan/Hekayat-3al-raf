import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_entities.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/repositories/i_submit_story_repository.dart';

class SubmitStoryRepositoryImpl implements ISubmitStoryRepository {
  const SubmitStoryRepositoryImpl();

  @override
  List<StoryTypeOptionEntity> getStoryTypeOptions() {
    return const [
      StoryTypeOptionEntity(
        format: StorySubmissionFormat.written,
        title: 'حكاية مكتوبة',
        description: 'اكتب حكايتك بكلماتك، بالطريقة اللي تريحك.',
        badges: ['نص حر', 'إضافة صور', 'حفظ كمسودة'],
      ),
      StoryTypeOptionEntity(
        format: StorySubmissionFormat.audio,
        title: 'حكاية صوتية',
        description: 'سجل صوتك وهو بيحكي الحكاية من أولها لآخرها.',
        badges: ['تسجيل مباشر', 'رفع ملف صوتي', 'تعديل قبل النشر'],
      ),
      StoryTypeOptionEntity(
        format: StorySubmissionFormat.video,
        title: 'حكاية مصورة',
        description: 'صور حكايتك بالفيديو، أو ارفع فيديو قديم.',
        badges: ['رفع فيديو', 'إضافة وصف', 'صور توضيحية'],
      ),
      StoryTypeOptionEntity(
        format: StorySubmissionFormat.document,
        title: 'وثيقة (PDF / Word)',
        description: 'عندك جواب، دفتر، أو ورقة قديمة؟ ارفعها زي ما هي.',
        badges: ['رفع PDF', 'رفع Word', 'صور الورقة'],
      ),
    ];
  }

  @override
  List<ReviewStepEntity> getReviewSteps() {
    return const [
      ReviewStepEntity(
        title: 'المراجعة',
        description: 'فريق صغير بيقرا الحكاية بعناية، ولو محتاجة حاجة بنرجعلك.',
      ),
      ReviewStepEntity(
        title: 'النشر',
        description: 'الحكاية بتاخد مكانها على الرف بعد موافقتك.',
      ),
      ReviewStepEntity(
        title: 'التفاعل',
        description: 'الناس تقرا وتسمع، والحكاية تفضل موجودة.',
      ),
    ];
  }
}

