import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants.dart';

class RecommendationService {
  static String get baseUrl => '${ApiConstants.baseUrl}/api/recommend';

  Future<String?> _readToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Get recommendations by barcode
  /// Returns: { scannedProduct, recommendations }
  Future<Map<String, dynamic>> getRecommendationsByBarcode(
    String barcode, {
    int topK = 5,
  }) async {
    try {
      final token = await _readToken();
      if (token == null) throw Exception('No authentication token found');

      final response = await http
          .post(
            Uri.parse('$baseUrl/barcode'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'barcode': barcode, 'top_k': topK}),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      }

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to get recommendations: ${response.statusCode}',
        );
      }

      final body = jsonDecode(response.body);
      if (body['success'] != true) {
        throw Exception(body['message'] ?? 'Unknown error');
      }

      final data = body['data'] as Map<String, dynamic>;
      return {
        'scannedProduct': data['scannedProduct'],
        'recommendations': List<Map<String, dynamic>>.from(
          data['recommendations'] ?? [],
        ),
      };
    } catch (e) {
      rethrow;
    }
  }

  /// Get recommendations by ingredients
  /// Returns: { ingredients, recommendations }
  Future<Map<String, dynamic>> getRecommendationsByIngredients(
    List<String> ingredients, {
    int topK = 5,
  }) async {
    try {
      final token = await _readToken();
      if (token == null) throw Exception('No authentication token found');

      final response = await http
          .post(
            Uri.parse(baseUrl),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({'ingredients': ingredients, 'top_k': topK}),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );

      if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please log in again');
      }

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to get recommendations: ${response.statusCode}',
        );
      }

      final body = jsonDecode(response.body);
      if (body['success'] != true) {
        throw Exception(body['message'] ?? 'Unknown error');
      }

      final data = body['data'] as Map<String, dynamic>;
      return {
        'ingredients': List<String>.from(data['ingredients'] ?? []),
        'recommendations': List<Map<String, dynamic>>.from(
          data['recommendations'] ?? [],
        ),
      };
    } catch (e) {
      rethrow;
    }
  }

  /// Health check for recommendation service
  Future<bool> healthCheck() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
