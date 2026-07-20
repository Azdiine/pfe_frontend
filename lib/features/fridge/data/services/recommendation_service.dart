import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants.dart';
import '../../../../core/services/api_client.dart';

class RecommendationService {
  static String get baseUrl => '${ApiConstants.baseUrl}/api/recommend';

  /// Get recommendations by barcode
  /// Returns: { scannedProduct, recommendations }
  Future<Map<String, dynamic>> getRecommendationsByBarcode(
    String barcode, {
    int topK = 5,
  }) async {
    final response = await ApiClient.post(
      Uri.parse('$baseUrl/barcode'),
      body: {'barcode': barcode, 'top_k': topK},
    );

    final body = jsonDecode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to get recommendations');
    }

    final data = body['data'] as Map<String, dynamic>;
    return {
      'scannedProduct': data['scannedProduct'],
      'recommendations': List<Map<String, dynamic>>.from(
        data['recommendations'] ?? [],
      ),
    };
  }

  /// Get recommendations by ingredients
  /// Returns: { ingredients, recommendations }
  Future<Map<String, dynamic>> getRecommendationsByIngredients(
    List<String> ingredients, {
    int topK = 5,
  }) async {
    final response = await ApiClient.post(
      Uri.parse(baseUrl),
      body: {'ingredients': ingredients, 'top_k': topK},
    );

    final body = jsonDecode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to get recommendations');
    }

    final data = body['data'] as Map<String, dynamic>;
    return {
      'ingredients': List<String>.from(data['ingredients'] ?? []),
      'recommendations': List<Map<String, dynamic>>.from(
        data['recommendations'] ?? [],
      ),
    };
  }

  /// Health check for recommendation service (endpoint public, sans auth)
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
