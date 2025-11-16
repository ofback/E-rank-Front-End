// E-rank-Front-End/lib/services/team_service.dart
import 'dart:convert';
import 'package:erank_app/core/constants/api_constants.dart';
import 'package:erank_app/services/auth_storage.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter/foundation.dart';

class TeamService {
  // Método de criar time (Já estava correto)
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

    final url = Uri.parse('${ApiConstants.baseUrl}/times');

    final body = json.encode({
      'nome': name,
      'descricao': description,
      'memberIds': memberIds,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Padrão 'Bearer' correto
        },
        body: body,
      );

      // Backend retorna 201 Created (TimesController.java)
      if (response.statusCode == 201) {
        return true;
      } else {
        print(
            'Falha ao criar time. Status: ${response.statusCode} | Body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro em TeamService.createTeam: $e');
      return false;
    }
  }

  // --- CORREÇÃO APLICADA AQUI ---
  // Método para buscar os times do usuário
  static Future<List<dynamic>> getMyTeams() async {
    final token = await AuthStorage.getToken();
    if (token == null) {
      throw Exception('Token não encontrado');
    }

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/times/me'),
      headers: {
        // 'Content-Type': 'application/json', // <-- LINHA REMOVIDA
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      // Lança exceção para ser capturada pelo FutureBuilder
      throw Exception('Falha ao carregar os times');
    }
  }

  // Método para sair do time (Já estava correto)
  static Future<bool> leaveTeam(int teamId) async {
    final token = await AuthStorage.getToken();
    // Você precisa implementar a lógica para buscar o ID do usuário no AuthStorage
    // Exemplo:
    // final userId = await AuthStorage.getUserId();
    final userId = await AuthStorage.getUserId(); // Assumindo que você tem isso

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

      // Backend retorna 204 No Content (TimesController.java)
      if (response.statusCode == 204) {
        return true;
      } else {
        print('Falha ao sair do time. Status: ${response.statusCode}');
        print('Corpo da resposta: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro em TeamService.leaveTeam: $e');
      return false;
    }
  }
}
