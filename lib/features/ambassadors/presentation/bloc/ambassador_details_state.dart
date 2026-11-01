import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/ambassadors/domain/entities/ambassador_details_entity.dart';

enum AmbassadorStatus { initial, loading, success, failure }

class AmbassadorDetailsState extends Equatable {
  final AmbassadorStatus status;
  final AmbassadorDetailsEntity? details;
  final String? errorMessage;
  final bool isSubmittingQuestion;
  final String? questionSubmitSuccess;

  const AmbassadorDetailsState({
    this.status = AmbassadorStatus.initial,
    this.details,
    this.errorMessage,
    this.isSubmittingQuestion = false,
    this.questionSubmitSuccess,
  });

  AmbassadorDetailsState copyWith({
    AmbassadorStatus? status,
    AmbassadorDetailsEntity? details,
    String? errorMessage,
    bool? isSubmittingQuestion,
    String? questionSubmitSuccess,
  }) {
    return AmbassadorDetailsState(
      status: status ?? this.status,
      details: details ?? this.details,
      errorMessage: errorMessage ?? this.errorMessage,
      isSubmittingQuestion: isSubmittingQuestion ?? this.isSubmittingQuestion,
      questionSubmitSuccess: questionSubmitSuccess,
    );
  }

  @override
  List<Object?> get props => [
        status,
        details,
        errorMessage,
        isSubmittingQuestion,
        questionSubmitSuccess,
      ];
}

