import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/locale_provider.dart' as app_locale;

/// 🌍 Code langue actuel ('fr' / 'en') sous forme de String.
///
/// Dérivé de l'unique source de vérité [app_locale.localeProvider]
/// (core/providers/locale_provider.dart), qui pilote aussi MaterialApp
/// et persiste le choix. Avant, ce fichier définissait un DEUXIÈME
/// provider indépendant : changer la langue depuis un écran ne mettait
/// pas à jour l'autre moitié de l'application.
///
/// Pour changer la langue :
/// ```dart
/// ref.read(app_locale.localeProvider.notifier).toggleLanguage();
/// ```
final localeProvider = Provider<String>((ref) {
  return ref.watch(app_locale.localeProvider).languageCode;
});
