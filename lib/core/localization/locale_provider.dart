import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🌍 Provider pour gérer la langue de l'application
/// Supporte Français (fr) et Anglais (en)
///
/// Usage:
/// ```dart
/// final locale = ref.watch(localeProvider);
/// ref.read(localeProvider.notifier).toggleLanguage();
/// ```

/// État de la langue actuelle
final localeProvider = StateNotifierProvider<LocaleNotifier, String>((ref) {
  return LocaleNotifier();
});

/// Notifier qui gère les changements de langue
class LocaleNotifier extends StateNotifier<String> {
  LocaleNotifier() : super('fr'); // Défaut: Français

  /// Basculer entre Français et Anglais
  void toggleLanguage() {
    state = state == 'fr' ? 'en' : 'fr';
  }

  /// Définir une langue spécifique
  void setLanguage(String languageCode) {
    if (languageCode == 'fr' || languageCode == 'en') {
      state = languageCode;
    }
  }

  /// Obtenir le nom complet de la langue actuelle
  String get currentLanguageName => state == 'fr' ? 'Français' : 'English';

  /// Obtenir le drapeau emoji de la langue actuelle
  String get currentLanguageFlag => state == 'fr' ? '🇫🇷' : '🇬🇧';
}
