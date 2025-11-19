import 'package:erank_app/services/api_client.dart';

class SocialService {
  // --- Buscar Meus Amigos ---
  static Future<List<dynamic>> getMyFriends() async {
    try {
      final response = await ApiClient.get('/amizades/meus-amigos');
      final data = ApiClient.handleResponse(response);
      return data as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

  // --- Buscar Convites Pendentes ---
  static Future<List<dynamic>> getFriendRequests() async {
    try {
      final response = await ApiClient.get('/amizades/convites');
      final data = ApiClient.handleResponse(response);
      return data as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

  // --- Enviar Pedido de Amizade ---
  static Future<bool> sendFriendRequest(int receiverId) async {
    try {
      // O endpoint espera { "idAmigo": ... } ou { "idUsuario2": ... } ?
      // Baseado no seu código anterior era 'idUsuario2', mas verifique se o DTO do backend bate.
      // Vou manter 'idUsuario2' conforme seu código original.
      final response = await ApiClient.post(
        '/amizades',
        body: {'idUsuario2': receiverId},
      );
      ApiClient.handleResponse(response);
      return true;
    } catch (e) {
      return false;
    }
  }

  // --- Pesquisar Usuários ---
  static Future<List<dynamic>> searchUsers(String nickname) async {
    if (nickname.isEmpty) return [];

    try {
      final response = await ApiClient.get('/usuarios?nickname=$nickname');
      final data = ApiClient.handleResponse(response);
      return data as List<dynamic>;
    } catch (e) {
      // Se der 404 (não encontrado) ou outro erro, retornamos lista vazia
      // para a tela exibir "Nenhum usuário encontrado".
      return [];
    }
  }

  // --- Aceitar Pedido ---
  static Future<bool> acceptFriendRequest(int friendshipId) async {
    try {
      final response = await ApiClient.patch(
        '/amizades/$friendshipId',
        body: {'status': 'A'},
      );
      ApiClient.handleResponse(response);
      return true;
    } catch (e) {
      return false;
    }
  }

  // --- Recusar ou Remover Amigo ---
  static Future<bool> declineOrRemoveFriendship(int friendshipId) async {
    try {
      final response = await ApiClient.delete('/amizades/$friendshipId');
      // 204 No Content é tratado como sucesso no handleResponse (retorna map vazio)
      ApiClient.handleResponse(response);
      return true;
    } catch (e) {
      return false;
    }
  }
}
