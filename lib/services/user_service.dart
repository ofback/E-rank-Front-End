import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_storage.dart';
import 'package:erank_app/core/constants/api_constants.dart';

class UserService {
  static Future<bool> updateMyProfile(Map<String, String> profileData) async {
    final token = await AuthStorage.getToken();
    if (token == null) return false;

    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/usuarios/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(profileData),
    );

    return response.statusCode == 200;
  }

  static Future<Map<String, dynamic>?> fetchMyProfile() async {
    final token = await AuthStorage.getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/usuarios/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }

    return null;
  }

  static Future<bool> updateProfile(
      String userId, Map<String, dynamic> data) async {
    final token = await AuthStorage.getToken();
    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/$userId'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteAccount(String userId) async {
    final token = await AuthStorage.getToken();
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}/$userId'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      await AuthStorage.logout();
      return true;
    }
    return false;
  }
}
