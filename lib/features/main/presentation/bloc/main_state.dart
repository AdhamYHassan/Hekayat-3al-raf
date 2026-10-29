import 'package:equatable/equatable.dart';

enum MainTab { home, stories, ambassadors, submit, more }

class MainState extends Equatable {
  final MainTab currentTab;

  const MainState({this.currentTab = MainTab.home});

  int get selectedIndex => currentTab.index;

  MainState copyWith({MainTab? currentTab}) {
    return MainState(currentTab: currentTab ?? this.currentTab);
  }

  @override
  List<Object?> get props => [currentTab];
}

