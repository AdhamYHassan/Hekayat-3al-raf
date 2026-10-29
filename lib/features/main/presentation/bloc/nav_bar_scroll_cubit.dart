import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hekayat_3al_raf/features/main/presentation/bloc/nav_bar_scroll_state.dart';

class NavBarScrollCubit extends Cubit<NavBarScrollState> {
  NavBarScrollCubit() : super(const NavBarScrollState());

  /// حد الإزاحة بالبكسل قبل تحويل البار إلى الكبسولة المصغرة
  static const double scrollThreshold = 25.0;

  void onScrollOffsetChanged(double pixels) {
    final shouldBeScrolled = pixels > scrollThreshold;
    if (shouldBeScrolled != state.isScrolled) {
      emit(state.copyWith(isScrolled: shouldBeScrolled));
    }
  }

  void reset() {
    if (state.isScrolled) {
      emit(const NavBarScrollState(isScrolled: false));
    }
  }
}

