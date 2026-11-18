import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/profile/domain/entities/user_message_entity.dart';

sealed class MyMessagesState extends Equatable {
  const MyMessagesState();

  @override
  List<Object?> get props => [];
}

class MyMessagesInitial extends MyMessagesState {
  const MyMessagesInitial();
}

class MyMessagesLoading extends MyMessagesState {
  const MyMessagesLoading();
}

class MyMessagesLoaded extends MyMessagesState {
  final List<UserMessageEntity> messages;

  const MyMessagesLoaded(this.messages);

  int get totalCount => messages.length;
  int get repliedCount => messages.where((m) => m.isReplied).length;
  int get pendingCount => messages.where((m) => !m.isReplied).length;

  @override
  List<Object?> get props => [messages];
}

class MyMessagesError extends MyMessagesState {
  final String message;

  const MyMessagesError(this.message);

  @override
  List<Object?> get props => [message];
}
