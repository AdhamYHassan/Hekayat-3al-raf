import 'package:hekayat_3al_raf/features/submit_story/data/datasources/i_submit_story_local_data_source.dart';
import 'package:hekayat_3al_raf/features/submit_story/data/models/story_draft_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubmitStoryLocalDataSource implements ISubmitStoryLocalDataSource {
  static const String _draftKey = 'hekayat_submit_story_draft_v1';
  final SharedPreferences _prefs;

  const SubmitStoryLocalDataSource(this._prefs);

  @override
  Future<void> saveDraft(StoryDraftModel draft) async {
    await _prefs.setString(_draftKey, draft.encode());
  }

  @override
  Future<StoryDraftModel?> getDraft() async {
    final raw = _prefs.getString(_draftKey);
    return StoryDraftModel.decode(raw);
  }

  @override
  Future<void> clearDraft() async {
    await _prefs.remove(_draftKey);
  }
}

