import 'package:erank_app/services/api_client.dart';
import 'package:erank_app/models/player_card.dart';

class EstatisticasService {
  // Registrar o resultado de uma partida
  static Future<bool> registrarResultado({
    required int desafioId,
    required bool vitoria,
    required int pontos,
    int kills = 0,
    int deaths = 0,
    int assists = 0,
    int headshots = 0,
  }) async {
    try {
      final body = {
        'desafioId': desafioId,
        'vitoria': vitoria,
        'pontos': pontos,
        'kills': kills,
        'deaths': deaths,
        'assistencias': assists,
        'headshots': headshots,
        'dadosExtras': 'Registrado via App' // Campo opcional
      };

      final response = await ApiClient.post('/estatisticas', body: body);
      ApiClient.handleResponse(response); // Lança exceção se der erro
      return true;
    } catch (e) {
      // Você pode relançar o erro ou tratar aqui.
      // Recomendo relançar para a tela mostrar o Snackbar.
      rethrow;
    }
  }

  static Future<PlayerCard?> getMyPlayerCard() async {
    try {
      final response = await ApiClient.get('/estatisticas/me/card');
      final data = ApiClient.handleResponse(response);
      return PlayerCard.fromJson(data);
    } catch (e) {
      return null;
    }
  }
}
