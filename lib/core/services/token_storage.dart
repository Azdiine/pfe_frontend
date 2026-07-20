import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

/// Point unique de stockage des tokens d'authentification.
/// Stockage chiffré (Keystore Android / Keychain iOS) via
/// flutter_secure_storage — plus jamais de token en clair sur le disque.
class TokenStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static bool _migrationDone = false;

  /// Migration one-shot depuis SharedPreferences (ancien stockage en clair) :
  /// les tokens existants sont déplacés vers le stockage chiffré puis effacés.
  static Future<void> _migrateFromPrefsIfNeeded() async {
    if (_migrationDone) return;
    _migrationDone = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final legacyToken = prefs.getString(AppConstants.tokenKey);
      if (legacyToken != null) {
        await _storage.write(key: AppConstants.tokenKey, value: legacyToken);
        await prefs.remove(AppConstants.tokenKey);
      }
      final legacyRefresh = prefs.getString(AppConstants.refreshTokenKey);
      if (legacyRefresh != null) {
        await _storage.write(
            key: AppConstants.refreshTokenKey, value: legacyRefresh);
        await prefs.remove(AppConstants.refreshTokenKey);
      }
    } catch (_) {
      // Pas de migration possible (ex: tests) — on continue sans bloquer
    }
  }

  static Future<String?> getToken() async {
    await _migrateFromPrefsIfNeeded();
    return _storage.read(key: AppConstants.tokenKey);
  }

  static Future<String?> getRefreshToken() async {
    await _migrateFromPrefsIfNeeded();
    return _storage.read(key: AppConstants.refreshTokenKey);
  }

  static Future<void> saveTokens({
    required String token,
    String? refreshToken,
  }) async {
    await _storage.write(key: AppConstants.tokenKey, value: token);
    if (refreshToken != null) {
      await _storage.write(
          key: AppConstants.refreshTokenKey, value: refreshToken);
    }
  }

  static Future<void> clear() async {
    await _storage.delete(key: AppConstants.tokenKey);
    await _storage.delete(key: AppConstants.refreshTokenKey);
  }
}
