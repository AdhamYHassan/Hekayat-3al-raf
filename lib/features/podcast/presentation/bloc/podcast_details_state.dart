import 'package:equatable/equatable.dart';
import 'package:hekayat_3al_raf/features/podcast/domain/entities/podcast_details_entity.dart';

enum PodcastDetailsStatus { initial, loading, success, failure }

class PodcastDetailsState extends Equatable {
  final PodcastDetailsStatus status;
  final PodcastDetailsEntity? podcast;
  final String? errorMessage;

  const PodcastDetailsState({
    this.status = PodcastDetailsStatus.initial,
    this.podcast,
    this.errorMessage,
  });

  PodcastDetailsState copyWith({
    PodcastDetailsStatus? status,
    PodcastDetailsEntity? podcast,
    String? errorMessage,
  }) {
    return PodcastDetailsState(
      status: status ?? this.status,
      podcast: podcast ?? this.podcast,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, podcast, errorMessage];
}
