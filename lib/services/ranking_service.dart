import 'package:erank_app/services/api_client.dart';
import 'package:erank_app/models/ranking_dto.dart';

class RankingService {
  Future<List<RankingDTO>> getGlobalRanking(
      {int page = 0, int size = 20}) async {
    try {
      // 1. Faz a requisição e recebe o objeto Response do http
      final response =
          await ApiClient.get('/rankings/global?page=$page&size=$size');

      // 2. Processa a resposta (decodifica JSON e trata erros)
      final data = ApiClient.handleResponse(response);

      // 3. Agora 'data' é um Map<String, dynamic>, podemos acessar ['content']
      if (data['content'] != null) {
        return (data['content'] as List)
            .map((e) => RankingDTO.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
