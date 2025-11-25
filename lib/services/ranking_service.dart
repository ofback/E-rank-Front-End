import 'package:erank_app/services/api_client.dart';
import 'package:erank_app/models/ranking_dto.dart';

class RankingService {
  // RF16: Busca ranking aceitando o tipo (GLOBAL ou AMIGOS)
  Future<List<RankingDTO>> getRanking(
      {int page = 0, int size = 20, String tipo = 'GLOBAL'}) async {
    try {
      // Chama o endpoint unificado passando o tipo
      final response = await ApiClient.get(
        '/rankings?page=$page&size=$size&tipo=$tipo',
      );

      final data = ApiClient.handleResponse(response);

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
