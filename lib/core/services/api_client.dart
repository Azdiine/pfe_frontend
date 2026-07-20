import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'token_storage.dart';

/// Client HTTP authentifié partagé par tous les services de données.
///
/// Gère automatiquement :
///  - l'ajout du header `Authorization: Bearer`,
///  - le refresh du token quand une requête reçoit un 401
///    (un seul refresh à la fois, les requêtes concurrentes attendent le même),
///  - la purge des tokens + redirection vers /login quand la session est
///    définitivement invalide (ex: tokens émis avant un changement de secret).
class ApiClient {
  /// Branché dans main.dart sur `goRouter.go('/login')`
  /// (callback pour éviter un import circulaire avec routes.dart).
  static void Function()? onSessionExpired;

  /// Refresh en cours : les 401 simultanés attendent le même futur au lieu
  /// de déclencher plusieurs rotations (la 2e invaliderait la 1re).
  static Future<String?>? _refreshInFlight;

  static Future<http.Response> get(Uri uri) => _request('GET', uri);

  static Future<http.Response> post(Uri uri, {Map<String, dynamic>? body}) =>
      _request('POST', uri, body: body);

  static Future<http.Response> put(Uri uri, {Map<String, dynamic>? body}) =>
      _request('PUT', uri, body: body);

  static Future<http.Response> delete(Uri uri, {Map<String, dynamic>? body}) =>
      _request('DELETE', uri, body: body);

  static Future<http.Response> _request(
    String method,
    Uri uri, {
    Map<String, dynamic>? body,
  }) async {
    final token = await TokenStorage.getToken();
    if (token == null) {
      return _expireSession();
    }

    var response = await _send(method, uri, token, body);

    if (response.statusCode == 401) {
      final newToken = await tryRefresh();
      if (newToken == null) {
        return _expireSession();
      }
      response = await _send(method, uri, newToken, body);
      if (response.statusCode == 401) {
        return _expireSession();
      }
    }

    return response;
  }

  static Future<http.Response> _send(
    String method,
    Uri uri,
    String token,
    Map<String, dynamic>? body,
  ) {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final encoded = body != null ? jsonEncode(body) : null;
    final Future<http.Response> future = switch (method) {
      'GET' => http.get(uri, headers: headers),
      'POST' => http.post(uri, headers: headers, body: encoded),
      'PUT' => http.put(uri, headers: headers, body: encoded),
      'DELETE' => http.delete(uri, headers: headers, body: encoded),
      _ => throw ArgumentError('Unsupported HTTP method: $method'),
    };
    return future.timeout(ApiConstants.connectionTimeout);
  }

  /// Échange le refresh token stocké contre une nouvelle paire de tokens.
  /// Renvoie le nouvel access token, ou null si le refresh est impossible.
  static Future<String?> tryRefresh() {
    return _refreshInFlight ??=
        _doRefresh().whenComplete(() => _refreshInFlight = null);
  }

  static Future<String?> _doRefresh() async {
    final refreshToken = await TokenStorage.getRefreshToken();
    if (refreshToken == null) return null;

    try {
      final response = await http
          .post(
            Uri.parse('${ApiConstants.baseUrl}/api/auth/refresh'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refreshToken': refreshToken}),
          )
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode != 200) return null;

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>;
      final newToken = data['token'] as String;
      await TokenStorage.saveTokens(
        token: newToken,
        refreshToken: data['refreshToken'] as String?,
      );
      return newToken;
    } catch (_) {
      return null;
    }
  }

  static Future<http.Response> _expireSession() async {
    await TokenStorage.clear();
    onSessionExpired?.call();
    throw Exception('Session expirée, veuillez vous reconnecter.');
  }
}
