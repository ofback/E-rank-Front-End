import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static final _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id'; // Chave para o ID do usuário

  // --- Métodos do Token ---
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // --- Métodos do User ID (A serem adicionados) ---
  static Future<void> saveUserId(int userId) async {
    await _storage.write(key: _userIdKey, value: userId.toString());
  }

  static Future<int?> getUserId() async {
    final userIdString = await _storage.read(key: _userIdKey);
    if (userIdString == null) {
      return null;
    }
    return int.tryParse(userIdString);
  }

  static Future<void> deleteUserId() async {
    await _storage.delete(key: _userIdKey);
  }

  // --- Método de Logout completo ---
  static Future<void> logout() async {
    await deleteToken();
    await deleteUserId();
  }
}
