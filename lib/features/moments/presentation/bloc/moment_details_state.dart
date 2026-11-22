import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/moments/domain/entities/moment_details_entity.dart';

enum MomentDetailsStatus { initial, loading, success, failure }

class MomentDetailsState extends Equatable {
  final MomentDetailsStatus status;
  final MomentDetailsEntity? moment;
  final String? errorMessage;

  const MomentDetailsState({
    this.status = MomentDetailsStatus.initial,
    this.moment,
    this.errorMessage,
  });

  MomentDetailsState copyWith({
    MomentDetailsStatus? status,
    MomentDetailsEntity? moment,
    String? errorMessage,
  }) {
    return MomentDetailsState(
      status: status ?? this.status,
      moment: moment ?? this.moment,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, moment, errorMessage];
}
