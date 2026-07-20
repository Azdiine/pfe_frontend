import 'dart:convert';
import '../../../core/constants.dart';
import '../../../core/services/api_client.dart';

/// Client API du chatbot Meatay Assistant.
/// Parle au backend Node (/api/chatbot) qui relaie vers le
/// microservice Flask (moteur sémantique meatay_chatbot_data.pt).
class ChatbotService {
  static String get baseUrl => '${ApiConstants.baseUrl}/api/chatbot';

  /// Envoie un message à Meatay Assistant.
  /// Returns: { sessionId, userMessage, botMessage, score, isFallback }
  Future<Map<String, dynamic>> sendMessage(
    String message, {
    String? sessionId,
  }) async {
    final response = await ApiClient.post(
      Uri.parse('$baseUrl/message'),
      body: {
        'message': message,
        'sessionId': ?sessionId,
      },
    );

    final body = jsonDecode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to send message');
    }

    return Map<String, dynamic>.from(body['data']);
  }

  /// Historique de conversation (optionnellement filtré par session).
  Future<List<Map<String, dynamic>>> getHistory({String? sessionId}) async {
    final uri = Uri.parse('$baseUrl/history').replace(
      queryParameters: sessionId != null ? {'sessionId': sessionId} : null,
    );

    final response = await ApiClient.get(uri);

    final body = jsonDecode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to load history');
    }

    return List<Map<String, dynamic>>.from(body['data'] ?? []);
  }

  /// Efface l'historique (optionnellement une seule session).
  Future<void> clearHistory({String? sessionId}) async {
    final uri = Uri.parse('$baseUrl/history').replace(
      queryParameters: sessionId != null ? {'sessionId': sessionId} : null,
    );

    final response = await ApiClient.delete(uri);

    final body = jsonDecode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to clear history');
    }
  }
}
