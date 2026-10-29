import 'package:equatable/equatable.dart';

/// Entity representing cultural ambassadors on the home screen.
class AmbassadorFeedItem extends Equatable {
  final String id;
  final String name;
  final String role;
  final String portraitUrl;

  const AmbassadorFeedItem({
    required this.id,
    required this.name,
    required this.role,
    required this.portraitUrl,
  });

  @override
  List<Object?> get props => [id, name, role, portraitUrl];
}

/// Entity representing cultural regions (Egypt, Levant, Gulf, Sudan).
class RegionArchiveItem extends Equatable {
  final String id;
  final String name;
  final String citiesSummary;
  final String tagline;
  final String photoUrl;

  const RegionArchiveItem({
    required this.id,
    required this.name,
    required this.citiesSummary,
    required this.tagline,
    required this.photoUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        citiesSummary,
        tagline,
        photoUrl,
      ];
}

