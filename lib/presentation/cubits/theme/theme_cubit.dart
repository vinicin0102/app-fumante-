import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

/// Cubit para gerenciar tema do app
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  /// Alterna para modo claro
  void setLightMode() {
    emit(state.copyWith(themeMode: ThemeMode.light));
  }

  /// Alterna para modo escuro
  void setDarkMode() {
    emit(state.copyWith(themeMode: ThemeMode.dark));
  }

  /// Segue o tema do sistema
  void setSystemMode() {
    emit(state.copyWith(themeMode: ThemeMode.system));
  }

  /// Alterna entre claro e escuro
  void toggleTheme() {
    if (state.themeMode == ThemeMode.dark) {
      setLightMode();
    } else {
      setDarkMode();
    }
  }
}
