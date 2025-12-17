import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/screens/challenges/active_matches_screen.dart';
import 'package:erank_app/screens/challenges/challenges_list_screen.dart';
import 'package:erank_app/screens/challenges/create_challenge_screen.dart';
import 'package:erank_app/screens/ranking/ranking_screen.dart';
import 'package:erank_app/screens/stats/stats_screen.dart';
import 'package:erank_app/screens/teams/team_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:erank_app/services/team_service.dart';
import 'package:erank_app/services/auth_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _myTeamsFuture;

  @override
  void initState() {
    super.initState();
    _loadMyTeams();
  }

  void _loadMyTeams() {
    setState(() {
      _myTeamsFuture = TeamService.getMyTeams();
    });
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'E-RANK',
          style: GoogleFonts.bevan(
            fontSize: 28,
            color: Colors.white,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          _buildActionButton(Icons.emoji_events, Colors.amber, 'Ranking', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const RankingScreen()));
          }),
          _buildActionButton(
              Icons.sports_kabaddi, Colors.blueAccent, 'Desafios', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ChallengesListScreen()));
          }),
          _buildActionButton(
              Icons.sports_esports, Colors.greenAccent, 'Partidas', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ActiveMatchesScreen()));
          }),
          _buildActionButton(Icons.bar_chart, Colors.purpleAccent, 'Stats', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const StatsScreen()));
          }),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white54),
            tooltip: 'Sair',
            onPressed: () async {
              await AuthStorage.logout();
              // Lógica de redirecionamento ou refresh pode ser adicionada aqui
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            child: Text(
              'Meus Times',
              style: GoogleFonts.exo2(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                  letterSpacing: 1),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _myTeamsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.group_off_outlined,
                            size: 60,
                            color: Colors.white.withValues(alpha: 0.3)),
                        const SizedBox(height: 10),
                        Text('Você ainda não faz parte de um time.',
                            style: GoogleFonts.poppins(color: Colors.white54)),
                      ],
                    ),
                  );
                }

                final myTeams = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: myTeams.length,
                  itemBuilder: (context, index) {
                    final team = myTeams[index];
                    return _buildTeamCard(team);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateChallengeScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        elevation: 10,
        icon: const Icon(Icons.flash_on, color: Colors.white),
        label: Text('DESAFIAR',
            style: GoogleFonts.exo2(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildActionButton(
      IconData icon, Color color, String tooltip, VoidCallback onTap) {
    return IconButton(
      icon: Icon(icon, color: color),
      tooltip: tooltip,
      onPressed: onTap,
    );
  }

  Widget _buildTeamCard(dynamic team) {
    final int teamId = team['id'] ?? 0;
    final String teamName = team['nome'] ?? 'Sem Nome';
    final String teamCargo = team['cargo'] ?? 'Membro';
    final String teamStatus = team['status'] ?? 'P';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (teamStatus == 'A') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TeamDetailsScreen(team: team),
                ),
              ).then((_) => _loadMyTeams());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Aceite o convite primeiro.")),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shield,
                          color: Colors.blueAccent, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            teamName,
                            style: GoogleFonts.exo2(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            teamStatus == 'A'
                                ? teamCargo.toUpperCase()
                                : 'PENDENTE',
                            style: GoogleFonts.poppins(
                                color: teamStatus == 'A'
                                    ? Colors.white54
                                    : Colors.orangeAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    if (teamStatus == 'A')
                      IconButton(
                        icon: const Icon(Icons.exit_to_app,
                            color: Colors.redAccent),
                        onPressed: () =>
                            _showLeaveTeamDialog(context, teamId, teamName),
                      ),
                  ],
                ),
                if (teamStatus != 'A') ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.green.withValues(alpha: 0.8),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          onPressed: () async {
                            try {
                              await TeamService.respondInvite(teamId, true);
                              _loadMyTeams();
                            } catch (e) {
                              _showError(e.toString());
                            }
                          },
                          child: const Text("Aceitar",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.redAccent),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          onPressed: () async {
                            try {
                              await TeamService.respondInvite(teamId, false);
                              _loadMyTeams();
                            } catch (e) {
                              _showError(e.toString());
                            }
                          },
                          child: const Text("Recusar",
                              style: TextStyle(color: Colors.redAccent)),
                        ),
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLeaveTeamDialog(BuildContext context, int teamId, String teamName) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E2C),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Sair do Time',
              style: GoogleFonts.exo2(color: Colors.white)),
          content: Text('Tem certeza que deseja sair de "$teamName"?',
              style: GoogleFonts.poppins(color: Colors.white70)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar',
                  style: TextStyle(color: Colors.white54)),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('SAIR',
                  style: TextStyle(
                      color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onPressed: () async {
                final userId = await AuthStorage.getUserId();
                if (userId == null) return;
                try {
                  await TeamService.removeMember(teamId, userId);
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                  _loadMyTeams();
                } catch (e) {
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                  if (mounted) _showError('Erro: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }
}
