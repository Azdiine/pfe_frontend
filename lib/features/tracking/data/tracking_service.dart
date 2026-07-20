import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants.dart';
import '../../../core/services/api_client.dart';

/// Client API du suivi journalier (DailyLog) :
/// repas, eau, poids/activité, historique de progression.
class TrackingService {
  static String get baseUrl => '${ApiConstants.baseUrl}/api/tracking';

  Map<String, dynamic> _parse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode != 200 || body['success'] != true) {
      throw Exception(body['message'] ?? 'Tracking request failed');
    }
    return body;
  }

  /// Ajoute un repas au journal du jour, rattaché à un type de repas
  /// (breakfast / lunch / dinner / snack). Renvoie le résumé complet du jour
  /// (totaux, repas groupés, objectifs personnalisés).
  Future<Map<String, dynamic>> addMeal({
    required double calories,
    double proteinsG = 0,
    double carbsG = 0,
    double fatsG = 0,
    String mealType = 'snack',
    String? name,
    String? source,
  }) async {
    final response = await ApiClient.post(
      Uri.parse('$baseUrl/meal'),
      body: {
        'calories': calories,
        'proteinsG': proteinsG,
        'carbsG': carbsG,
        'fatsG': fatsG,
        'mealType': mealType,
        'name': ?name,
        'source': ?source,
      },
    );
    return Map<String, dynamic>.from(_parse(response)['data']);
  }

  /// Supprime une entrée de repas. Renvoie le résumé du jour mis à jour.
  Future<Map<String, dynamic>> deleteMeal(String entryId) async {
    final response =
        await ApiClient.delete(Uri.parse('$baseUrl/meal/$entryId'));
    return Map<String, dynamic>.from(_parse(response)['data']);
  }

  /// Ajoute de l'eau (ml) au journal du jour.
  Future<Map<String, dynamic>> addWater(int ml) async {
    final response = await ApiClient.post(
      Uri.parse('$baseUrl/water'),
      body: {'ml': ml},
    );
    return Map<String, dynamic>.from(_parse(response)['data']);
  }

  /// Met à jour les valeurs du jour (poids, activité, humeur...).
  Future<Map<String, dynamic>> updateDay(Map<String, dynamic> fields) async {
    final response = await ApiClient.put(
      Uri.parse('$baseUrl/daily'),
      body: fields,
    );
    return Map<String, dynamic>.from(_parse(response)['data']);
  }

  /// Journal d'un jour (aujourd'hui par défaut).
  Future<Map<String, dynamic>> getDay({String? date}) async {
    final uri = Uri.parse('$baseUrl/daily')
        .replace(queryParameters: date != null ? {'date': date} : null);
    final response = await ApiClient.get(uri);
    return Map<String, dynamic>.from(_parse(response)['data']);
  }

  /// Journaux des N derniers jours (progression).
  Future<List<Map<String, dynamic>>> getRange({int days = 7}) async {
    final uri = Uri.parse('$baseUrl/range')
        .replace(queryParameters: {'days': '$days'});
    final response = await ApiClient.get(uri);
    return List<Map<String, dynamic>>.from(_parse(response)['data'] ?? []);
  }
}
