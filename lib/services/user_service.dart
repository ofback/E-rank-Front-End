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
        // CORREÇÃO (Ponto 2): Padronizado para 'Bearer $token'
        'Authorization': 'Bearer $token',
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
        // CORREÇÃO (Ponto 2): Padronizado para 'Bearer $token'
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // O backend agora retorna diretamente o objeto do usuário logado.
      return json.decode(response.body) as Map<String, dynamic>;
    }

    return null;
  }

  // Update - atualizar dados (Método antigo/de admin)
  static Future<bool> updateProfile(
      String userId, Map<String, dynamic> data) async {
    final token = await AuthStorage.getToken();
    final response = await http.put(
      // CORREÇÃO (Ponto 4): Usando ApiConstants.baseUrl
      Uri.parse('${ApiConstants.baseUrl}/$userId'),
      headers: {
        'Content-Type': 'application/json',
        // Este já estava correto (Ponto 2)
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );
    return response.statusCode == 200;
  }

  // Delete - excluir conta (Método antigo/de admin)
  static Future<bool> deleteAccount(String userId) async {
    final token = await AuthStorage.getToken();
    final response = await http.delete(
      // CORREÇÃO (Ponto 4): Usando ApiConstants.baseUrl
      Uri.parse('${ApiConstants.baseUrl}/$userId'),
      headers: {
        'Content-Type': 'application/json',
        // Este já estava correto (Ponto 2)
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      // CORREÇÃO (Ponto 3): Método corrigido de 'clearUserData' para 'logout'
      await AuthStorage.logout(); // limpa login
      return true;
    }
    return false;
  }
}
