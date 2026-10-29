import 'package:equatable/equatable.dart';

class NavBarScrollState extends Equatable {
  final bool isScrolled;

  const NavBarScrollState({this.isScrolled = false});

  NavBarScrollState copyWith({bool? isScrolled}) {
    return NavBarScrollState(isScrolled: isScrolled ?? this.isScrolled);
  }

  @override
  List<Object?> get props => [isScrolled];
}

