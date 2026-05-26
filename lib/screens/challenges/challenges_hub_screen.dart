import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/models/challenge.dart';
import 'package:erank_app/screens/challenges/register_result_screen.dart';
import 'package:erank_app/screens/challenges/create_challenge_screen.dart';
import 'package:erank_app/services/api_client.dart';
import 'package:erank_app/services/challenge_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Hub centralizado de Desafios.
/// Agrega "Pendentes" e "Partidas Ativas" em tabs, com FAB para criar desafio.
class ChallengesHubScreen extends StatefulWidget {
  const ChallengesHubScreen({super.key});

  @override
  State<ChallengesHubScreen> createState() => _ChallengesHubScreenState();
}

class _ChallengesHubScreenState extends State<ChallengesHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late Future<List<Challenge>> _pendingFuture;
  late Future<List<Challenge>> _activeFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _refreshAll();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refreshAll() {
    setState(() {
      _pendingFuture = ChallengeService.getPendingChallenges();
      _activeFuture = _fetchAcceptedChallenges();
    });
  }

  Future<List<Challenge>> _fetchAcceptedChallenges() async {
    final response = await ApiClient.get('/desafios/aceitos');
    final data = ApiClient.handleResponse(response);
    return (data as List).map((json) => Challenge.fromJson(json)).toList();
  }

  void _respondPending(int id, bool accept) async {
    try {
      await ChallengeService.respondChallenge(id, accept);
      _refreshAll();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(accept ? 'Desafio aceito!' : 'Desafio recusado.'),
          backgroundColor:
              accept ? AppColors.success : AppColors.surfaceLight,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Erro: $e'), backgroundColor: AppColors.danger),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'DESAFIOS',
          style: GoogleFonts.bevan(
              color: AppColors.textPrimary, fontSize: 24, letterSpacing: 1.5),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.textPrimary,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: GoogleFonts.exo2(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'PENDENTES', icon: Icon(Icons.sports_kabaddi, size: 18)),
            Tab(text: 'ATIVAS', icon: Icon(Icons.sports_esports, size: 18)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PendingTab(
            future: _pendingFuture,
            onRespond: _respondPending,
            onRefresh: _refreshAll,
          ),
          _ActiveTab(
            future: _activeFuture,
            onRefresh: _refreshAll,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const CreateChallengeScreen()),
          );
          _refreshAll();
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.flash_on, color: AppColors.textPrimary),
        label: Text(
          'DESAFIAR',
          style: GoogleFonts.exo2(
              color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// ─── Aba de Desafios Pendentes ─────────────────────────────────────────────────

class _PendingTab extends StatelessWidget {
  final Future<List<Challenge>> future;
  final void Function(int id, bool accept) onRespond;
  final VoidCallback onRefresh;

  const _PendingTab({
    required this.future,
    required this.onRespond,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Challenge>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Erro: ${snapshot.error}',
                style: GoogleFonts.poppins(color: AppColors.danger)),
          );
        }

        final list = snapshot.data ?? [];

        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline,
                    size: 64,
                    color: AppColors.textPrimary.withValues(alpha: 0.2)),
                const SizedBox(height: 12),
                Text('Nenhum desafio pendente.',
                    style:
                        GoogleFonts.poppins(color: AppColors.textSecondary)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final challenge = list[index];
            return _buildPendingCard(challenge);
          },
        );
      },
    );
  }

  Widget _buildPendingCard(Challenge challenge) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.sports_kabaddi,
                      color: AppColors.primary, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Desafio de ${challenge.desafianteNome}',
                        style: GoogleFonts.exo2(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Text(
                        'Data: ${challenge.dataHora}',
                        style: GoogleFonts.poppins(
                            color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.pending.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.pending.withValues(alpha: 0.5)),
                  ),
                  child: Text('PENDENTE',
                      style: GoogleFonts.exo2(
                          color: AppColors.pending,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: AppColors.borderSubtle, height: 1),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.danger,
                      side: BorderSide(
                          color: AppColors.danger.withValues(alpha: 0.6)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => onRespond(challenge.id, false),
                    icon: const Icon(Icons.close, size: 18),
                    label: Text('RECUSAR',
                        style: GoogleFonts.exo2(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => onRespond(challenge.id, true),
                    icon: const Icon(Icons.check,
                        size: 18, color: AppColors.textPrimary),
                    label: Text('ACEITAR',
                        style: GoogleFonts.exo2(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Aba de Partidas Ativas ────────────────────────────────────────────────────

class _ActiveTab extends StatelessWidget {
  final Future<List<Challenge>> future;
  final VoidCallback onRefresh;

  const _ActiveTab({required this.future, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Challenge>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Erro: ${snapshot.error}',
                style: GoogleFonts.poppins(color: AppColors.danger)),
          );
        }

        final list = snapshot.data ?? [];

        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sports_esports_outlined,
                    size: 64,
                    color: AppColors.textPrimary.withValues(alpha: 0.2)),
                const SizedBox(height: 12),
                Text('Nenhuma partida ativa.',
                    style:
                        GoogleFonts.poppins(color: AppColors.textSecondary)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final challenge = list[index];
            final bool jaRegistrei = challenge.status == 'AGUARDANDO';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.sports_esports,
                      color: AppColors.accent, size: 20),
                ),
                title: Text(
                  challenge.desafianteNome,
                  style: GoogleFonts.exo2(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Data: ${challenge.dataHora}',
                  style: GoogleFonts.poppins(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
                trailing: jaRegistrei
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color:
                                  AppColors.pending.withValues(alpha: 0.6)),
                          borderRadius: BorderRadius.circular(6),
                          color: AppColors.pending.withValues(alpha: 0.1),
                        ),
                        child: Text(
                          'Aguardando\nOponente',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: AppColors.pending, fontSize: 10),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RegisterResultScreen(challenge: challenge),
                            ),
                          );
                          onRefresh();
                        },
                        child: Text('REGISTRAR',
                            style: GoogleFonts.exo2(
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
