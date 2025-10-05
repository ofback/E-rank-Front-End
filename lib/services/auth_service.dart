import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:erank_app/core/constants/api_constants.dart';
import 'auth_storage.dart';

class AuthService {
  // Registrar um novo usuário
  // Rota correta: POST /usuarios
  static Future<void> logout() async {
    // Simplesmente limpa os dados do usuário salvos no dispositivo
    await AuthStorage.clearUserData();
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
  static Future<bool> login(String email, String password) async {
    // 1. Criamos o nosso "token" para HTTP Basic Auth.
    String basicAuth = 'Basic ${base64Encode(utf8.encode('$email:$password'))}';

    // 2. Tentamos acessar um endpoint que requer autenticação.
    //    O endpoint /amizades é uma boa escolha, pois qualquer usuário logado pode acessá-lo.
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/amizades'),
      headers: {
        'Authorization': basicAuth,
      },
    );

    // 3. Se a resposta for 200 (OK), as credenciais são válidas.
    if (response.statusCode == 200) {
      // Salvamos o "token" (basicAuth) e o email para usar em futuras requisições.
      await AuthStorage.saveUserData(basicAuth, email);
      return true;
    }

    // Se for 401 (Unauthorized) ou outro erro, o login falhou.
    return false;
  }
}
