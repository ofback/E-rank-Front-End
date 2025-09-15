import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_storage.dart';

class UserService {
  static const String baseUrl = 'http://10.0.2.2:8080/usuarios'; // ajuste se for device real

  // Read - buscar perfil
  static Future<Map<String, dynamic>?> fetchProfile(String userId) async {
    final token = await AuthStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/$userId'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  // Update - atualizar dados
  static Future<bool> updateProfile(String userId, Map<String, dynamic> data) async {
    final token = await AuthStorage.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/$userId'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );
    return response.statusCode == 200;
  }

  // Delete - excluir conta
  static Future<bool> deleteAccount(String userId) async {
    final token = await AuthStorage.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/$userId'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      await AuthStorage.clearUserData(); // limpa login
      return true;
    }
    return false;
  }
}
