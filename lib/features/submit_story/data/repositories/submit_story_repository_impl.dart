import 'package:dio/dio.dart';
import 'package:hekayat_3al_raf/core/network/failure.dart';
import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/submit_story/data/datasources/i_submit_story_local_data_source.dart';
import 'package:hekayat_3al_raf/features/submit_story/data/datasources/i_submit_story_remote_data_source.dart';
import 'package:hekayat_3al_raf/features/submit_story/data/models/story_draft_model.dart';
import 'package:hekayat_3al_raf/features/submit_story/data/models/submit_story_request_model.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/story_draft_entity.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_entities.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/entities/submit_story_params.dart';
import 'package:hekayat_3al_raf/features/submit_story/domain/repositories/i_submit_story_repository.dart';

class SubmitStoryRepositoryImpl implements ISubmitStoryRepository {
  final ISubmitStoryLocalDataSource _localDataSource;
  final ISubmitStoryRemoteDataSource _remoteDataSource;

  const SubmitStoryRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
  );

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

  @override
  Future<void> saveDraft(StoryDraftEntity draft) async {
    final model = StoryDraftModel.fromEntity(draft);
    await _localDataSource.saveDraft(model);
  }

  @override
  Future<StoryDraftEntity?> getDraft() async {
    return await _localDataSource.getDraft();
  }

  @override
  Future<void> clearDraft() async {
    await _localDataSource.clearDraft();
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> submitStory(
    SubmitStoryParams params,
  ) async {
    try {
      final request = SubmitStoryRequestModel(params);
      final response = await _remoteDataSource.submitStory(request);
      return ApiSuccess(response);
    } on DioException catch (e) {
      final errorMessage = e.response?.data is Map &&
              (e.response!.data as Map).containsKey('message')
          ? (e.response!.data as Map)['message'].toString()
          : e.message ?? 'تعذر إرسال الحكاية. يرجى المحاولة مرة أخرى.';
      return ApiFailure(
        ServerFailure(errorMessage, statusCode: e.response?.statusCode),
      );
    } catch (e) {
      return ApiFailure(ServerFailure('حدث خطأ غير متوقع: $e'));
    }
  }
}


