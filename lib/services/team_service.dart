import 'dart:convert';
import 'package:erank_app/core/constants/api_constants.dart';
import 'package:erank_app/services/auth_storage.dart';
import 'package:http/http.dart' as http;

class TeamService {
  static Future<bool> createTeam({
    required String name,
    required String description,
  }) async {
    final token = await AuthStorage.getToken();
    if (token == null) return false;

    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/times'),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'nome': name,
        'descricao': description,
      }),
    );

    return response.statusCode == 201; // Created
  }
}
