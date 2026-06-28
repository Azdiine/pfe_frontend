import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants.dart';
import 'auth_model.dart';

class AuthRepository {
  static const String _tokenKey = AppConstants.tokenKey;
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
      final user = AuthUser.fromJson(body['data']['user'] as Map<String, dynamic>);
      final token = body['data']['token'] as String;
      await _saveToken(token);
      return user.copyWith(token: token);
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
      final user = AuthUser.fromJson(body['data']['user'] as Map<String, dynamic>);
      final token = body['data']['token'] as String;
      await _saveToken(token);
      return user.copyWith(token: token);
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
        final data = body['data'] as Map<String, dynamic>;
        final user = AuthUser.fromJson(data['user'] as Map<String, dynamic>);
        final token = data['token'] as String;
        await _saveToken(token);
        return user.copyWith(token: token);
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
    final token = await getToken();
    if (token == null) return null;

    final response = await http
        .get(
          Uri.parse('$_baseUrl/api/auth/me'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(ApiConstants.connectionTimeout);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final user = AuthUser.fromJson(body['data'] as Map<String, dynamic>);
      return user.copyWith(token: token);
    }

    // Token invalide ou expiré
    await logout();
    return null;
  }

  // ── Logout ────────────────────────────────────────────────────────────────
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ── Refresh token ─────────────────────────────────────────────────────────
  Future<String> refreshToken(String oldToken) async {
    final response = await http
        .post(
          Uri.parse('$_baseUrl/api/auth/refresh'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $oldToken',
          },
        )
        .timeout(ApiConstants.connectionTimeout);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final newToken = body['data']['token'] as String;
      await _saveToken(newToken);
      return newToken;
    }

    throw Exception('Impossible de rafraîchir le token');
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }
}
