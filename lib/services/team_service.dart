import 'dart:convert';
import 'package:erank_app/core/constants/api_constants.dart';
import 'package:erank_app/services/api_client.dart';
import 'package:erank_app/models/team_member.dart';

class TeamService {
  // --- Listar Meus Times ---
  static Future<List<dynamic>> getMyTeams() async {
    try {
      final response = await ApiClient.get('/times/me');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Erro ao buscar times: $e');
    }
    return [];
  }

  // --- Criar Time ---
  static Future<bool> createTeam({
    required String name,
    required String description,
    required List<int> memberIds,
  }) async {
    final body = {
      'nome': name,
      'descricao': description,
      'memberIds': memberIds,
    };

    try {
      final response = await ApiClient.post('/times', body: body);
      return response.statusCode == 201;
    } catch (e) {
      print('Erro ao criar time: $e');
      return false;
    }
  }

  // --- NOVAS FUNÇÕES (RF08 - Gerenciamento de Membros) ---

  // 1. Buscar Membros
  static Future<List<TeamMember>> getTeamMembers(int teamId) async {
    try {
      final response = await ApiClient.get('/times/$teamId/members');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => TeamMember.fromJson(json)).toList();
      }
    } catch (e) {
      print('Erro ao buscar membros: $e');
    }
    return [];
  }

  // 2. Adicionar Membro
  static Future<bool> addMember(int teamId, int userId) async {
    try {
      final response = await ApiClient.post('/times/$teamId/members',
          body: {'userId': userId});
      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao adicionar membro: $e');
      return false;
    }
  }

  // 3. Alterar Cargo (Promover/Rebaixar)
  static Future<bool> updateRole(int teamId, int userId, String newRole) async {
    try {
      final response = await ApiClient.patch(
          '/times/$teamId/members/$userId/role',
          body: {'novoCargo': newRole});
      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao atualizar cargo: $e');
      return false;
    }
  }

  // 4. Remover Membro (Sair ou Expulsar)
  static Future<bool> removeMember(int teamId, int userId) async {
    try {
      final response = await ApiClient.delete('/times/$teamId/members/$userId');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Erro ao remover membro: $e');
      return false;
    }
  }

  // Wrapper para compatibilidade
  static Future<bool> leaveTeam(int teamId, int userId) async {
    return removeMember(teamId, userId);
  }
}
