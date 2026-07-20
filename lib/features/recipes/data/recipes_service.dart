import 'dart:convert';
import '../../../core/constants.dart';
import '../../../core/services/api_client.dart';

/// Client API des recettes du jour (catalogue Meatay via le
/// microservice de recommandation).
class RecipesService {
  static String get baseUrl => '${ApiConstants.baseUrl}/api/recommend';

  /// Recettes du jour. Sans [seed] : même sélection toute la journée.
  /// Avec un [seed] (ex: timestamp) : nouveau tirage aléatoire à chaque appel.
  Future<List<Map<String, dynamic>>> getDailyRecipes({
    int count = 6,
    String? seed,
  }) async {
    final response = await ApiClient.get(
      Uri.parse('$baseUrl/daily').replace(queryParameters: {
        'count': '$count',
        'seed': ?seed,
      }),
    );

    final body = jsonDecode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Failed to load daily recipes');
    }

    return List<Map<String, dynamic>>.from(body['data']['recipes'] ?? []);
  }
}
