import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/features/main/presentation/bloc/main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(const MainState());

  void changeTab(MainTab tab) {
    if (tab != state.currentTab) {
      emit(state.copyWith(currentTab: tab));
    }
  }

  void changeTabIndex(int index) {
    if (index >= 0 && index < MainTab.values.length) {
      changeTab(MainTab.values[index]);
    }
  }
}

