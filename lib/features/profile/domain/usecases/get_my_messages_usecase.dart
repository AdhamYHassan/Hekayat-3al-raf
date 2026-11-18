import 'package:hekayat_3al_raf/core/network/network_result.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/user_message_entity.dart';
import 'package:hekayat_3al_raf/features/profile/domain/repositories/i_profile_repository.dart';

/// Interactor for fetching the user's submitted messages/tickets.
/// Follows Single Responsibility and isolates Domain from presentation frameworks.
class GetMyMessagesUseCase {
  final IProfileRepository _repository;

  const GetMyMessagesUseCase(this._repository);

  Future<ApiResult<List<UserMessageEntity>>> call() {
    return _repository.getMyMessages();
  }
}
