import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUserService {
  static const String _usersKey = 'users';

  // Salvar um novo usuário
  static Future<bool> registerUser(Map<String, String> user) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> usersList = prefs.getStringList(_usersKey) ?? [];

    // Verifica se o email já existe
    for (var u in usersList) {
      final existingUser = json.decode(u) as Map<String, dynamic>;
      if (existingUser['email'] == user['email']) {
        return false; // Usuário já existe
      }
    }

    usersList.add(json.encode(user));
    await prefs.setStringList(_usersKey, usersList);
    return true;
  }

  // Verificar login
  static Future<bool> loginUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> usersList = prefs.getStringList(_usersKey) ?? [];

    for (var u in usersList) {
      final user = json.decode(u) as Map<String, dynamic>;
      if (user['email'] == email && user['senha'] == password) {
        return true; // Login correto
      }
    }
    return false; // Login incorreto
  }
}
