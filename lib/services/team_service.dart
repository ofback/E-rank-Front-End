import 'dart:convert';
import 'package:erank_app/core/constants/api_constants.dart';
import 'package:erank_app/services/auth_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Importe "required"

class TeamService {
  // CORREÇÃO: Método adicionado
  static Future<bool> createTeam({
    required String name,
    required String description,
    required List<int> memberIds,
  }) async {
    final token = await AuthStorage.getToken();
    if (token == null) {
      print('Erro: Token não encontrado.');
      return false;
    }

    // A rota para criar um time (geralmente POST no recurso principal)
    final url = Uri.parse('${ApiConstants.baseUrl}/times');

    // Mapeie os nomes da tela para os nomes que o backend espera
    final body = json.encode({
      'nome': name, // O backend espera 'nome'
      'descricao': description, // O backend espera 'descricao'
      'idsMembros': memberIds, // O backend espera 'idsMembros'
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Padrão que corrigimos
        },
        body: body,
      );

      // 201 (Created) é o status padrão para sucesso em um POST
      // Se sua API retornar 200, mude aqui para response.statusCode == 200
      if (response.statusCode == 201) {
        return true;
      } else {
        print(
            'Falha ao criar time. Status: ${response.statusCode} | Body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro de conexão ao tentar criar time: $e');
      return false;
    }
  }

  // Método que já existia (corrigido para static)
  static Future<List<dynamic>> getMyTeams() async {
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

  // Método que já existia (corrigido para static)
  static Future<bool> leaveTeam(int teamId) async {
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
