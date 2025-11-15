// E-rank-Front-End/lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:erank_app/core/constants/api_constants.dart';
import 'package:erank_app/services/auth_storage.dart';

class AuthService {
  // --- FUNÇÃO DE REGISTO CORRIGIDA ---
  static Future<bool> register(Map<String, String> user) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/usuarios');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user),
      );

      // 1. CORREÇÃO: Mudar a verificação de 200 para 201 (CREATED)
      //    O Spring retorna 201 para @PostMapping com @ResponseStatus(HttpStatus.CREATED)
      return response.statusCode == 201;
      //    (Alternativa mais robusta: return response.statusCode >= 200 && response.statusCode < 300;)
    } catch (e) {
      print('Erro no AuthService.register: $e');
      return false;
    }
  }

  // --- FUNÇÃO DE LOGIN (JÁ ESTAVA CORRETA, MAS MANTIDA) ---
  static Future<bool> login(String email, String password) async {
    // A URL '/login' está correta de acordo com o SecurityConfig
    final url = Uri.parse('${ApiConstants.baseUrl}/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': password}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['token'];

        if (token != null) {
          await AuthStorage.saveToken(token);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Erro no AuthService.login: $e');
      return false;
    }
  }

  // --- FUNÇÃO DE LOGOUT (JÁ ESTAVA CORRETA) ---
  static Future<void> logout() async {
    await AuthStorage.deleteToken();
  }
}
