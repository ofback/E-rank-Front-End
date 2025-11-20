import 'package:erank_app/services/api_client.dart';
import 'package:erank_app/models/challenge.dart';

class ChallengeService {
  // Criar desafio
  static Future<void> createChallenge(int desafiadoId, int jogoId) async {
    final response = await ApiClient.post(
      '/desafios',
      body: {
        'desafiadoId': desafiadoId,
        'jogoId': jogoId,
      },
    );
    ApiClient.handleResponse(response);
  }

  // Listar pendentes
  static Future<List<Challenge>> getPendingChallenges() async {
    final response = await ApiClient.get('/desafios/pendentes');
    final data = ApiClient.handleResponse(response);
    return (data as List).map((json) => Challenge.fromJson(json)).toList();
  }

  // CORREÇÃO: Mudado de 'boolean' para 'bool'
  static Future<void> respondChallenge(int id, bool accept) async {
    final response = await ApiClient.patch(
      '/desafios/$id/responder',
      body: {'aceitar': accept},
    );
    ApiClient.handleResponse(response);
  }
}
