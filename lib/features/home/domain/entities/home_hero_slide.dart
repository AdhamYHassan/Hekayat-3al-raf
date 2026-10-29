import 'package:equatable/equatable.dart';

/// Entity representing a hero banner slide on the home screen.
/// Pure Dart class independent of external frameworks or JSON contracts.
class HomeHeroSlide extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final String ctaLabel;
  final String? secondaryCtaLabel;

  const HomeHeroSlide({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.ctaLabel,
    this.secondaryCtaLabel,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        description,
        imageUrl,
        ctaLabel,
        secondaryCtaLabel,
      ];
}

