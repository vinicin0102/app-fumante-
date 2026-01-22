part of 'theme_cubit.dart';

/// Estado do tema
class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState({
    this.themeMode = ThemeMode.system,
  });

  bool get isDark => themeMode == ThemeMode.dark;
  bool get isLight => themeMode == ThemeMode.light;
  bool get isSystem => themeMode == ThemeMode.system;

  ThemeState copyWith({
    ThemeMode? themeMode,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [themeMode];
}
