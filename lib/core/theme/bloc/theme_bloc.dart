import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:barbqtonight/core/theme/colors.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc()
    : super(
        ThemeState(
          themeMode: ThemeMode.light,
          themeData: Palette.lightModeAppTheme,
        ),
      ) {
    on<ToggleThemeEvent>(_onToggleTheme);
    _loadThemeFromPreferences();
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (state.themeMode == ThemeMode.dark) {
      emit(
        ThemeState(
          themeMode: ThemeMode.light,
          themeData: Palette.lightModeAppTheme,
        ),
      );
      await prefs.setString('theme', 'light');
    } else {
      emit(
        ThemeState(
          themeMode: ThemeMode.dark,
          themeData: Palette.darkModeAppTheme,
        ),
      );
      await prefs.setString('theme', 'dark');
    }
  }

  Future<void> _loadThemeFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');

    if (theme == 'dark') {
      add(ToggleThemeEvent());
    }
  }
}
