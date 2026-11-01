import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_list_item_entity.dart';

enum AmbassadorsListStatus { initial, loading, success, failure }

class AmbassadorsListState extends Equatable {
  final AmbassadorsListStatus status;
  final List<AmbassadorListItemEntity> ambassadors;
  final String? errorMessage;

  const AmbassadorsListState({
    this.status = AmbassadorsListStatus.initial,
    this.ambassadors = const [],
    this.errorMessage,
  });

  AmbassadorsListState copyWith({
    AmbassadorsListStatus? status,
    List<AmbassadorListItemEntity>? ambassadors,
    String? errorMessage,
  }) {
    return AmbassadorsListState(
      status: status ?? this.status,
      ambassadors: ambassadors ?? this.ambassadors,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, ambassadors, errorMessage];
}

