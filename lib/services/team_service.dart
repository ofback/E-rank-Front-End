import 'package:erank_app/services/api_client.dart';
import 'package:erank_app/models/team_member.dart';

class TeamService {
  // --- Listar Meus Times ---
  static Future<List<dynamic>> getMyTeams() async {
    final response = await ApiClient.get('/times/me');
    // O handleResponse lança exceção se falhar, então não precisamos de try-catch aqui.
    // A UI deve capturar a exceção para mostrar o erro.
    final data = ApiClient.handleResponse(response);
    return data as List<dynamic>;
  }

  // --- Criar Time ---
  // Mudamos o retorno para Future<void>. Se der erro, lança Exception.
  // Se não der erro, assume-se sucesso (201 Created).
  static Future<void> createTeam({
    required String name,
    required String description,
    required List<int> memberIds,
  }) async {
    final body = {
      'nome': name,
      'descricao': description,
      'memberIds': memberIds,
    };

    final response = await ApiClient.post('/times', body: body);
    ApiClient.handleResponse(response);
  }

  // --- RF08 - Gerenciamento de Membros ---

  // 1. Buscar Membros
  static Future<List<TeamMember>> getTeamMembers(int teamId) async {
    final response = await ApiClient.get('/times/$teamId/members');
    final data = ApiClient.handleResponse(response);

    return (data as List).map((json) => TeamMember.fromJson(json)).toList();
  }

  // 2. Adicionar Membro
  static Future<void> addMember(int teamId, int userId) async {
    final response = await ApiClient.post(
      '/times/$teamId/members',
      body: {'userId': userId},
    );
    ApiClient.handleResponse(response);
  }

  // 3. Alterar Cargo (Promover/Rebaixar)
  static Future<void> updateRole(int teamId, int userId, String newRole) async {
    final response = await ApiClient.patch(
      '/times/$teamId/members/$userId/role',
      body: {'novoCargo': newRole},
    );
    ApiClient.handleResponse(response);
  }

  // 4. Remover Membro (Sair ou Expulsar)
  static Future<void> removeMember(int teamId, int userId) async {
    final response = await ApiClient.delete('/times/$teamId/members/$userId');
    ApiClient.handleResponse(response);
  }

  // Wrapper para compatibilidade (caso usado em outras partes)
  static Future<void> leaveTeam(int teamId, int userId) async {
    return removeMember(teamId, userId);
  }

  // Novo: Responder Convite
  static Future<void> respondInvite(int teamId, bool accept) async {
    final action = accept ? 'accept' : 'decline';
    final response = await ApiClient.post('/times/$teamId/invites/$action');
    ApiClient.handleResponse(response);
  }
}
