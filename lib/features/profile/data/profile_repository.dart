import 'dart:convert';
import '../../../core/constants.dart';
import '../../../core/services/api_client.dart';

class ProfileRepository {
  static const String _baseUrl = ApiConstants.baseUrl;

  // Get full profile from API
  Future<Map<String, dynamic>> getProfile() async {
    final response = await ApiClient.get(Uri.parse('$_baseUrl/api/profile'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['data'] as Map<String, dynamic>;
    }

    throw Exception('Failed to load profile');
  }

  // Update profile fields
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await ApiClient.put(
      Uri.parse('$_baseUrl/api/profile'),
      body: data,
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['data'] as Map<String, dynamic>;
    }

    throw Exception('Failed to update profile');
  }
}
