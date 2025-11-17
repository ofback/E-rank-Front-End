import 'dart:convert';
import 'package:erank_app/services/api_client.dart';
import 'package:erank_app/services/auth_storage.dart';

class AuthService {
  // REGISTRO
  static Future<bool> register(Map<String, String> user) async {
    try {
      // Usa o ApiClient (URL base já está configurada lá)
      final response = await ApiClient.post('/usuarios', body: user);

      // Backend retorna 201 Created
      return response.statusCode == 201;
    } catch (e) {
      print('Erro no AuthService.register: $e');
      return false;
    }
  }

  // LOGIN
  static Future<bool> login(String email, String password) async {
    try {
      final response = await ApiClient.post('/login',
          body: {'email': email, 'senha': password});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extrai dados do DTO (LoginResponseDTO)
        final token = data['token'];
        final usuario = data['usuario']; // Objeto usuário dentro da resposta

        if (token != null) {
          await AuthStorage.saveToken(token);

          // Salva o ID do usuário para validações futuras (RF08)
          if (usuario != null && usuario['id'] != null) {
            await AuthStorage.saveUserId(usuario['id']);
          }

          return true;
        }
      }
      return false;
    } catch (e) {
      print('Erro no AuthService.login: $e');
      return false;
    }
  }

  // LOGOUT
  static Future<void> logout() async {
    await AuthStorage.logout();
  }
}
