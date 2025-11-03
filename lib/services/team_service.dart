import 'dart:convert';
import 'package:erank_app/core/constants/api_constants.dart';
import 'package:erank_app/services/auth_storage.dart';
import 'package:http/http.dart' as http;

class TeamService {
  Future<List<dynamic>> getMyTeams() async {
    final token = await AuthStorage.getToken();
    if (token == null) {
      throw Exception('Token não encontrado');
    }

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/times/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Falha ao carregar os times');
    }
  }

  Future<bool> leaveTeam(int teamId) async {
    final token = await AuthStorage.getToken();
    final userId = await AuthStorage.getUserId();

    if (token == null || userId == null) {
      print('Erro: Token ou User ID não encontrados.');
      return false;
    }

    final url =
        Uri.parse('${ApiConstants.baseUrl}/times/$teamId/members/$userId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        print('Falha ao sair do time. Status: ${response.statusCode}');
        print('Corpo da resposta: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro de conexão ao tentar sair do time: $e');
      return false;
    }
  }
}
