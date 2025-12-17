import 'package:erank_app/services/api_client.dart';
import 'package:erank_app/models/team_member.dart';

class TeamService {
  static Future<List<dynamic>> getMyTeams() async {
    final response = await ApiClient.get('/times/me');
    final data = ApiClient.handleResponse(response);
    return data as List<dynamic>;
  }

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

  static Future<List<TeamMember>> getTeamMembers(int teamId) async {
    final response = await ApiClient.get('/times/$teamId/members');
    final data = ApiClient.handleResponse(response);

    return (data as List).map((json) => TeamMember.fromJson(json)).toList();
  }

  static Future<void> addMember(int teamId, int userId) async {
    final response = await ApiClient.post(
      '/times/$teamId/members',
      body: {'userId': userId},
    );
    ApiClient.handleResponse(response);
  }

  static Future<void> updateRole(int teamId, int userId, String newRole) async {
    final response = await ApiClient.patch(
      '/times/$teamId/members/$userId/role',
      body: {'novoCargo': newRole},
    );
    ApiClient.handleResponse(response);
  }

  static Future<void> removeMember(int teamId, int userId) async {
    final response = await ApiClient.delete('/times/$teamId/members/$userId');
    ApiClient.handleResponse(response);
  }

  static Future<void> leaveTeam(int teamId, int userId) async {
    return removeMember(teamId, userId);
  }

  static Future<void> respondInvite(int teamId, bool accept) async {
    final action = accept ? 'accept' : 'decline';
    final response = await ApiClient.post('/times/$teamId/invites/$action');
    ApiClient.handleResponse(response);
  }
}
