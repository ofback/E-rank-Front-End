import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:erank_app/core/constants/api_constants.dart';
import 'auth_storage.dart';

class AuthService {
  // Registrar um novo usuário
  // Rota correta: POST /usuarios
  static Future<void> logout() async {
    // Simplesmente limpa os dados do usuário salvos no dispositivo
    await AuthStorage.logout();
  }

  static Future<bool> register(Map<String, String> userData) async {
    final response = await http.post(
      Uri.parse(
          '${ApiConstants.baseUrl}/usuarios'), // Rota correta do seu backend
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userData),
    );
    // Seu backend retorna 201 (Created) em caso de sucesso no UsuariosController.
    return response.statusCode == 201;
  }

  // Fazer login
  // Não há endpoint de login. Validamos as credenciais tentando acessar um recurso protegido.

  // CORREÇÃO: Adicionamos a palavra-chave "static" aqui
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('${ApiConstants.baseUrl}/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'senha': password}),
      );

      if (response.statusCode == 200) {
        // Decodifica a resposta JSON em um Mapa
        final Map<String, dynamic> responseData = json.decode(response.body);

        // --- Linha de Depuração ---
        // Esta linha vai imprimir a resposta completa da API no seu console.
        // Procure por uma linha que começa com "DEBUG LOGIN RESPONSE:"
        print('DEBUG LOGIN RESPONSE: $responseData');
        // -------------------------

        // Verifica se a resposta contém as chaves 'token' e 'usuario'
        if (responseData.containsKey('token') &&
            responseData.containsKey('usuario')) {
          final token = responseData['token'] as String;
          // Acessa o mapa do usuário, que contém o ID
          final usuarioData = responseData['usuario'] as Map<String, dynamic>;
          final userId = usuarioData['id'] as int;

          // Salva o token e o ID do usuário
          await AuthStorage.saveToken(token);
          await AuthStorage.saveUserId(userId);

          return true;
        } else {
          // Se as chaves não existirem, a resposta da API é inesperada.
          print('Erro: A resposta do login não contém as chaves esperadas.');
          return false;
        }
      } else {
        // Falha no login (ex: senha errada)
        print('Falha no login. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Erro de rede ou outro problema
      print('Erro ao tentar fazer login: $e');
      return false;
    }
  }
}
