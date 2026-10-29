import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:base_app/core/helpers/shared_prefs_helper.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(_getInitialTheme());

  static ThemeMode _getInitialTheme() {
    final themeStr = SharedPrefsHelper.getThemeMode();
    if (themeStr == 'light') return ThemeMode.light;
    return ThemeMode.dark;
  }

  void toggleTheme() {
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    SharedPrefsHelper.setThemeMode(newTheme == ThemeMode.light ? 'light' : 'dark');
    emit(newTheme);
  }
}
