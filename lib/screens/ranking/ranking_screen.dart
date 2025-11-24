import 'package:flutter/material.dart';
import 'package:erank_app/models/ranking_dto.dart';
import 'package:erank_app/services/ranking_service.dart';

class RankingScreen extends StatefulWidget {
  // CORREÇÃO: Uso de super parameters
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final RankingService _service = RankingService();
  List<RankingDTO> _players = [];
  bool _isLoading = true;
  int _currentPage = 0;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadRanking();
  }

  Future<void> _loadRanking() async {
    if (!_hasMore) return;

    try {
      final newPlayers = await _service.getGlobalRanking(page: _currentPage);

      // CORREÇÃO: Verifica se a tela ainda está ativa antes de usar setState ou Context
      if (!mounted) return;

      setState(() {
        if (newPlayers.length < 20) _hasMore = false;

        if (_currentPage == 0) {
          _players = newPlayers;
        } else {
          _players.addAll(newPlayers);
        }

        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar ranking: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ranking Global')),
      body: _isLoading && _players.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _players.length + (_hasMore ? 1 : 0),
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                if (index == _players.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: TextButton(
                        onPressed: _isLoading ? null : _loadRanking,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text("Carregar mais..."),
                      ),
                    ),
                  );
                }

                final player = _players[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        player.posicao <= 3 ? Colors.amber : Colors.grey[300],
                    child: Text('#${player.posicao}',
                        style: TextStyle(
                            color: player.posicao <= 3
                                ? Colors.black
                                : Colors.grey[800],
                            fontWeight: FontWeight.bold)),
                  ),
                  title: Text(player.nickname,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Vitórias: ${player.vitorias} | Kills: ${player.kills}'),
                  trailing: Text(
                    '${player.pontuacao} pts',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                );
              },
            ),
    );
  }
}
