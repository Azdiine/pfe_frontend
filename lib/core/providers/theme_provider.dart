import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Key used to store the selected theme mode in SharedPreferences
const String _kThemeModeStorageKey = 'theme_mode';

/// StateNotifier to manage theme mode changes
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light) {
    _loadThemeMode();
  }

  /// Load theme mode from SharedPreferences
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeMode = prefs.getString(_kThemeModeStorageKey);

      if (savedThemeMode != null) {
        state = _themeModeFromString(savedThemeMode);
      } else {
        // Use system theme as default
        state = ThemeMode.system;
      }
    } catch (e) {
      // If loading fails, keep default theme mode
      state = ThemeMode.light;
    }
  }

  /// Set and persist theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kThemeModeStorageKey, mode.toString());
    } catch (e) {
      // Silently fail if persistence fails
    }
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }

  /// Check if current theme is dark
  bool get isDarkMode => state == ThemeMode.dark;

  /// Convert string to ThemeMode
  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }
}

/// Provider for theme mode management
///
/// Usage:
/// ```dart
/// // Watch theme mode changes
/// final themeMode = ref.watch(themeModeProvider);
///
/// // Toggle theme
/// ref.read(themeModeProvider.notifier).toggleTheme();
///
/// // Set specific theme
/// ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
/// ```
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier();
});
