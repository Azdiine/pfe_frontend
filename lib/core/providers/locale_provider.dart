import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Key used to store the selected locale in SharedPreferences
const String _kLocaleStorageKey = 'selected_locale';

/// Supported locales for the application
class SupportedLocales {
  static const Locale english = Locale('en');
  static const Locale french = Locale('fr');

  static const List<Locale> all = [english, french];

  /// Get locale from language code
  static Locale fromCode(String code) {
    switch (code) {
      case 'en':
        return english;
      case 'fr':
        return french;
      default:
        return english; // Fallback to English
    }
  }

  /// Get language name from locale
  static String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      default:
        return 'English';
    }
  }

  /// Get flag emoji from locale
  static String getFlagEmoji(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return '🇺🇸';
      case 'fr':
        return '🇫🇷';
      default:
        return '🇺🇸';
    }
  }
}

/// StateNotifier for managing the app locale with persistence
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(SupportedLocales.french) {
    // Load saved locale on initialization
    _loadSavedLocale();
  }

  /// Load the saved locale from SharedPreferences
  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocaleCode = prefs.getString(_kLocaleStorageKey);

      if (savedLocaleCode != null) {
        // Use saved locale
        state = SupportedLocales.fromCode(savedLocaleCode);
      } else {
        // Auto-detect device language on first launch
        final deviceLocale = PlatformDispatcher.instance.locale;
        final deviceLanguageCode = deviceLocale.languageCode;

        // Check if device language is supported
        if (SupportedLocales.all
            .any((locale) => locale.languageCode == deviceLanguageCode)) {
          state = SupportedLocales.fromCode(deviceLanguageCode);
          // Save the auto-detected language
          await _saveLocale(state);
        } else {
          // Fallback to French if device language not supported
          state = SupportedLocales.french;
          await _saveLocale(state);
        }
      }
    } catch (e) {
      // If error, fallback to French
      state = SupportedLocales.french;
    }
  }

  /// Save the current locale to SharedPreferences
  Future<void> _saveLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLocaleStorageKey, locale.languageCode);
    } catch (e) {
      // Handle error silently
    }
  }

  /// Change the app locale to the specified language
  Future<void> setLocale(Locale locale) async {
    if (state.languageCode != locale.languageCode) {
      state = locale;
      await _saveLocale(locale);
    }
  }

  /// Toggle between English and French
  Future<void> toggleLanguage() async {
    final newLocale = state.languageCode == 'en'
        ? SupportedLocales.french
        : SupportedLocales.english;
    await setLocale(newLocale);
  }

  /// Get current language name
  String get currentLanguageName => SupportedLocales.getLanguageName(state);

  /// Get current language flag emoji
  String get currentLanguageFlag => SupportedLocales.getFlagEmoji(state);

  /// Check if current language is English
  bool get isEnglish => state.languageCode == 'en';

  /// Check if current language is French
  bool get isFrench => state.languageCode == 'fr';
}

/// Provider for the locale notifier
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
