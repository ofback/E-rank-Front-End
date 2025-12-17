import 'package:flutter/material.dart';
import 'package:erank_app/models/ranking_dto.dart';
import 'package:erank_app/services/ranking_service.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen>
    with SingleTickerProviderStateMixin {
  final RankingService _service = RankingService();
  late TabController _tabController;

  List<RankingDTO> _players = [];
  bool _isLoading = false;
  int _currentPage = 0;
  bool _hasMore = true;
  String _currentTipo = 'GLOBAL';

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);

    _loadRanking();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;

    final novoTipo = _tabController.index == 0 ? 'GLOBAL' : 'AMIGOS';

    if (_currentTipo != novoTipo) {
      setState(() {
        _currentTipo = novoTipo;
        _resetList();
      });
      _loadRanking();
    }
  }

  void _resetList() {
    _players = [];
    _currentPage = 0;
    _hasMore = true;
    _isLoading = true;
  }

  Future<void> _loadRanking() async {
    if (!_hasMore && _currentPage > 0) return;

    setState(() => _isLoading = true);

    try {
      final newPlayers =
          await _service.getRanking(page: _currentPage, tipo: _currentTipo);

      if (!mounted) return;

      setState(() {
        if (newPlayers.length < 20) _hasMore = false;

        _players.addAll(newPlayers);
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
      appBar: AppBar(
        title: const Text('Ranking'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Global', icon: Icon(Icons.public)),
            Tab(text: 'Amigos', icon: Icon(Icons.people)),
          ],
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_isLoading &&
              _hasMore &&
              scrollInfo.metrics.pixels >=
                  scrollInfo.metrics.maxScrollExtent - 200) {
            _loadRanking();
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () async {
            _resetList();
            await _loadRanking();
          },
          child: _players.isEmpty && _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _players.isEmpty && !_isLoading
                  ? const Center(
                      child: Text("Nenhum jogador encontrado no ranking."))
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: _players.length + (_hasMore ? 1 : 0),
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        if (index == _players.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final player = _players[index];
                        final posicao = index + 1;

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                posicao <= 3 ? Colors.amber : Colors.grey[300],
                            foregroundColor:
                                posicao <= 3 ? Colors.black : Colors.black87,
                            child: Text('#$posicao',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                          title: Text(
                            player.nickname,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'V: ${player.vitorias} | K: ${player.kills}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${player.pontuacao}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              const Text('PTS',
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
