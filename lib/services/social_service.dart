import 'package:erank_app/services/api_client.dart';

class SocialService {
  static Future<List<dynamic>> getMyFriends() async {
    try {
      final response = await ApiClient.get('/amizades/meus-amigos');
      final data = ApiClient.handleResponse(response);
      return data as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> getFriendRequests() async {
    try {
      final response = await ApiClient.get('/amizades/convites');
      final data = ApiClient.handleResponse(response);
      return data as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

  static Future<bool> sendFriendRequest(int receiverId) async {
    try {
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

  static Future<List<dynamic>> searchUsers(String nickname) async {
    if (nickname.isEmpty) return [];

    try {
      final response = await ApiClient.get('/usuarios?nickname=$nickname');
      final data = ApiClient.handleResponse(response);
      return data as List<dynamic>;
    } catch (e) {
      return [];
    }
  }

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

  static Future<bool> declineOrRemoveFriendship(int friendshipId) async {
    try {
      final response = await ApiClient.delete('/amizades/$friendshipId');
      ApiClient.handleResponse(response);
      return true;
    } catch (e) {
      return false;
    }
  }
}
