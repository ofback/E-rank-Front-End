import 'dart:convert';
import 'package:erank_app/services/api_client.dart';
import 'package:erank_app/services/auth_storage.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  // REGISTRO
  static Future<bool> register(Map<String, String> user) async {
    try {
      final response = await ApiClient.post('/usuarios', body: user);
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('Erro no AuthService.register: $e');
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

        final token = data['token'];
        final usuario = data['usuario'];

        if (token != null) {
          await AuthStorage.saveToken(token);

          if (usuario != null && usuario['id'] != null) {
            await AuthStorage.saveUserId(usuario['id']);
          }

          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Erro no AuthService.login: $e');
      return false;
    }
  }

  // LOGOUT
  static Future<void> logout() async {
    await AuthStorage.logout();
  }
}
