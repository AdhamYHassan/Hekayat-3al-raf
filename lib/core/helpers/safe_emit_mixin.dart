import 'package:flutter_bloc/flutter_bloc.dart';

mixin SafeEmitMixin<State> on Cubit<State> {
  @override
  void emit(State state) {
    if (isClosed) return;
    super.emit(state);
  }
}
