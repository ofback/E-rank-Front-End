import 'package:flutter/material.dart';
import 'package:erank_app/models/ranking_dto.dart';
import 'package:erank_app/services/ranking_service.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: const Color(0xFF0F0C29),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background_neon.png',
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) =>
                  Container(color: const Color(0xFF0F0C29)),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('RANKING',
                  style: GoogleFonts.bevan(color: Colors.white)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.blueAccent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                labelStyle: GoogleFonts.exo2(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'GLOBAL', icon: Icon(Icons.public)),
                  Tab(text: 'AMIGOS', icon: Icon(Icons.people)),
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
                color: Colors.blueAccent,
                backgroundColor: const Color(0xFF1E1E2C),
                onRefresh: () async {
                  _resetList();
                  await _loadRanking();
                },
                child: _players.isEmpty && _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _players.isEmpty && !_isLoading
                        ? Center(
                            child: Text(
                              "Nenhum jogador encontrado no ranking.",
                              style: GoogleFonts.poppins(color: Colors.white54),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _players.length + (_hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == _players.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }

                              final player = _players[index];
                              final posicao = index + 1;

                              Color? rankColor;
                              if (posicao == 1)
                                rankColor = Colors.amber;
                              else if (posicao == 2)
                                rankColor = Colors.grey[300];
                              else if (posicao == 3)
                                rankColor = Colors.orange[300];

                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1E2C)
                                      .withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: rankColor?.withValues(alpha: 0.5) ??
                                        Colors.white10,
                                    width: rankColor != null ? 1.5 : 1,
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: rankColor ?? Colors.white10,
                                      shape: BoxShape.circle,
                                      boxShadow: rankColor != null
                                          ? [
                                              BoxShadow(
                                                  color: rankColor.withValues(
                                                      alpha: 0.6),
                                                  blurRadius: 10)
                                            ]
                                          : null,
                                    ),
                                    child: Text(
                                      '#$posicao',
                                      style: GoogleFonts.bevan(
                                        color: rankColor != null
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    player.nickname,
                                    style: GoogleFonts.exo2(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'V: ${player.vitorias} | K: ${player.kills}',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white54, fontSize: 12),
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize
                                        .min, // <--- CRÍTICO: Previne overflow
                                    children: [
                                      Text(
                                        '${player.pontuacao}',
                                        style: GoogleFonts.bevan(
                                          fontSize: 18,
                                          color: Colors.blueAccent,
                                        ),
                                      ),
                                      Text(
                                        'PTS',
                                        style: GoogleFonts.exo2(
                                            fontSize: 10,
                                            color: Colors.white38),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
