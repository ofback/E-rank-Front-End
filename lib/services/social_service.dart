import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:erank_app/core/constants/api_constants.dart';
import 'package:erank_app/services/auth_storage.dart';

class SocialService {
  static Future<List<dynamic>> searchUsers(String nickname) async {
    final token = await AuthStorage.getToken();
    if (token == null || nickname.isEmpty) return [];

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/usuarios?nickname=$nickname'),
      headers: {
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    }

    return [];
  }
}
