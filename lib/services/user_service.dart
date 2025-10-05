import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_storage.dart';
import 'package:erank_app/core/constants/api_constants.dart';

class UserService {
  static const String baseUrl =
      ApiConstants.baseUrl; // ajuste se for device real

  static Future<bool> updateMyProfile(Map<String, String> profileData) async {
    final token = await AuthStorage.getToken();
    if (token == null) return false;

    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}/usuarios/me'),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
      body: json.encode(profileData),
    );

    // O backend retorna 200 OK em caso de sucesso
    return response.statusCode == 200;
  }

  // Read - buscar perfil
  static Future<Map<String, dynamic>?> fetchMyProfile() async {
    final token = await AuthStorage.getToken();
    if (token == null) return null;

    // Agora fazemos a chamada para o endpoint correto e eficiente!
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/usuarios/me'),
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // O backend agora retorna diretamente o objeto do usuário logado.
      return json.decode(response.body) as Map<String, dynamic>;
    }

    return null;
  }

  // Update - atualizar dados
  static Future<bool> updateProfile(
      String userId, Map<String, dynamic> data) async {
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
