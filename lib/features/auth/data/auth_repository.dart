import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/token_storage.dart';
import 'auth_model.dart';

class AuthRepository {
  static const String _baseUrl = ApiConstants.baseUrl;

  // ── Register (no user created yet — just sends OTP) ────────────────────────
  Future<void> register(String email, String password, String name) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/api/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password, 'name': name}),
        )
        .timeout(ApiConstants.connectionTimeout);

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 201) {
      return; // OTP sent, no user yet
    }

    throw Exception(body['message'] ?? 'Erreur lors de l\'inscription');
  }

  // ── Verify OTP ─────────────────────────────────────────────────────────────
  Future<AuthUser> verifyOtp(String email, String code) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/api/auth/verify-otp'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'code': code}),
        )
        .timeout(ApiConstants.connectionTimeout);

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return _saveAuthData(body['data'] as Map<String, dynamic>);
    }

    throw Exception(body['message'] ?? 'Code OTP invalide');
  }

  // ── Resend OTP ────────────────────────────────────────────────────────────
  Future<void> resendOtp(String email) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/api/auth/resend-otp'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email}),
        )
        .timeout(ApiConstants.connectionTimeout);

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(body['message'] ?? 'Erreur lors du renvoi du code');
    }
  }

  // ── Login ─────────────────────────────────────────────────────────────────
  Future<AuthUser> login(String email, String password) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/api/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'password': password}),
        )
        .timeout(ApiConstants.connectionTimeout);

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return _saveAuthData(body['data'] as Map<String, dynamic>);
    }

    throw Exception(body['message'] ?? 'Email ou mot de passe incorrect');
  }

  // ── Google OAuth 2.0 ──────────────────────────────────────────────────────
  Future<AuthUser> googleAuth(String idToken) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/api/auth/google'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'idToken': idToken}),
          )
          .timeout(ApiConstants.connectionTimeout);

      final body = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return _saveAuthData(body['data'] as Map<String, dynamic>);
      }

      throw Exception(body['message'] ?? 'Erreur d\'authentification Google');
    } on http.ClientException catch (e) {
      throw Exception('Impossible de contacter le serveur ($_baseUrl): ${e.message}');
    } on FormatException {
      throw Exception('Réponse serveur invalide pour Google Sign-In');
    } on Exception {
      rethrow;
    } catch (e) {
      throw Exception('Erreur réseau Google Sign-In: $e');
    }
  }

  // ── Get current user (via stored token) ───────────────────────────────────
  Future<AuthUser?> getCurrentUser() async {
    final token = await TokenStorage.getToken();
    if (token == null) return null;

    var response = await http
        .get(
          Uri.parse('$_baseUrl/api/auth/me'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(ApiConstants.connectionTimeout);

    // Access token expiré → une tentative de refresh avant d'abandonner
    if (response.statusCode == 401) {
      final newToken = await _tryRefreshToken();
      if (newToken == null) {
        await TokenStorage.clear();
        return null;
      }
      response = await http
          .get(
            Uri.parse('$_baseUrl/api/auth/me'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $newToken',
            },
          )
          .timeout(ApiConstants.connectionTimeout);
    }

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final user = AuthUser.fromJson(body['data'] as Map<String, dynamic>);
      final currentToken = await TokenStorage.getToken();
      return user.copyWith(token: currentToken);
    }

    await TokenStorage.clear();
    return null;
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    // Révocation de la session côté serveur (best effort : le logout
    // local doit réussir même si le réseau est coupé)
    final token = await TokenStorage.getToken();
    final refreshToken = await TokenStorage.getRefreshToken();
    if (token != null) {
      try {
        await http
            .post(
              Uri.parse('$_baseUrl/api/auth/logout'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode({'refreshToken': ?refreshToken}),
            )
            .timeout(ApiConstants.connectionTimeout);
      } catch (_) {
        // Ignoré : la session expirera d'elle-même côté serveur
      }
    }
    await TokenStorage.clear();
  }

  // ── Refresh token ─────────────────────────────────────────────────────────
  /// Échange le refresh token stocké contre une nouvelle paire de tokens.
  /// Retourne le nouvel access token, ou lève une exception si impossible.
  Future<String> refreshToken() async {
    final newToken = await _tryRefreshToken();
    if (newToken == null) {
      throw Exception('Impossible de rafraîchir le token');
    }
    return newToken;
  }

  // Même implémentation (single-flight) que le reste de l'app
  Future<String?> _tryRefreshToken() => ApiClient.tryRefresh();

  // ── Mot de passe ──────────────────────────────────────────────────────────

  /// Changement de mot de passe (connecté). Le backend révoque toutes les
  /// sessions et renvoie une nouvelle paire de tokens pour cet appareil.
  Future<void> changePassword(String currentPassword, String newPassword) async {
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception('Non connecté');

    final response = await http
        .put(
          Uri.parse('$_baseUrl/api/auth/change-password'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'currentPassword': currentPassword,
            'newPassword': newPassword,
          }),
        )
        .timeout(ApiConstants.connectionTimeout);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Impossible de changer le mot de passe');
    }

    final data = body['data'] as Map<String, dynamic>;
    await TokenStorage.saveTokens(
      token: data['token'] as String,
      refreshToken: data['refreshToken'] as String?,
    );
  }

  /// Envoie un code de réinitialisation par email (mot de passe oublié).
  Future<void> forgotPassword(String email) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/api/auth/forgot-password'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email}),
        )
        .timeout(ApiConstants.connectionTimeout);

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(body['message'] ?? 'Impossible d\'envoyer le code');
    }
  }

  /// Réinitialise le mot de passe avec le code reçu par email.
  Future<void> resetPassword(String email, String code, String newPassword) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/api/auth/reset-password'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'code': code,
            'newPassword': newPassword,
          }),
        )
        .timeout(ApiConstants.connectionTimeout);

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(body['message'] ?? 'Code invalide ou expiré');
    }
  }

  // ── Sessions actives ──────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> listSessions() async {
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception('Non connecté');
    final refreshToken = await TokenStorage.getRefreshToken();

    final response = await http
        .post(
          Uri.parse('$_baseUrl/api/auth/sessions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({'refreshToken': ?refreshToken}),
        )
        .timeout(ApiConstants.connectionTimeout);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      throw Exception(body['message'] ?? 'Impossible de charger les sessions');
    }
    return List<Map<String, dynamic>>.from(body['data'] ?? []);
  }

  Future<void> revokeSession(String sessionId) async {
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception('Non connecté');

    final response = await http
        .delete(
          Uri.parse('$_baseUrl/api/auth/sessions/$sessionId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(ApiConstants.connectionTimeout);

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(body['message'] ?? 'Impossible de révoquer la session');
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Future<AuthUser> _saveAuthData(Map<String, dynamic> data) async {
    final user = AuthUser.fromJson(data['user'] as Map<String, dynamic>);
    final token = data['token'] as String;
    await TokenStorage.saveTokens(
      token: token,
      refreshToken: data['refreshToken'] as String?,
    );
    return user.copyWith(token: token);
  }

  Future<String?> getToken() => TokenStorage.getToken();
}
