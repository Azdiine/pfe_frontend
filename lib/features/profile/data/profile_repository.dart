import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants.dart';

class ProfileRepository {
  static const String _baseUrl = ApiConstants.baseUrl;

  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Get full profile from API
  Future<Map<String, dynamic>> getProfile() async {
    final headers = await _authHeaders();
    final response = await http
        .get(
          Uri.parse('$_baseUrl/api/profile'),
          headers: headers,
        )
        .timeout(ApiConstants.connectionTimeout);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['data'] as Map<String, dynamic>;
    }

    throw Exception('Failed to load profile');
  }

  // Update profile fields
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final headers = await _authHeaders();
    final response = await http
        .put(
          Uri.parse('$_baseUrl/api/profile'),
          headers: headers,
          body: jsonEncode(data),
        )
        .timeout(ApiConstants.connectionTimeout);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['data'] as Map<String, dynamic>;
    }

    throw Exception('Failed to update profile');
  }
}
