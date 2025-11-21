import 'package:erank_app/services/api_client.dart';
import 'package:erank_app/models/game.dart';

class GameService {
  static Future<List<Game>> getGames() async {
    try {
      final response =
          await ApiClient.get('/jogos'); // Ajuste se sua rota for diferente
      final data = ApiClient.handleResponse(response);
      return (data as List).map((json) => Game.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }
}
