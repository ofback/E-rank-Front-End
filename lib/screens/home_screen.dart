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
      SnackBar(content: Text(message), backgroundColor: AppColors.danger),
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
            color: AppColors.textPrimary,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          _buildActionButton(Icons.emoji_events, AppColors.gold, 'Ranking', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const RankingScreen()));
          }),
          _buildActionButton(
              Icons.sports_kabaddi, AppColors.info, 'Desafios', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ChallengesListScreen()));
          }),
          _buildActionButton(
              Icons.sports_esports, AppColors.accent, 'Partidas', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ActiveMatchesScreen()));
          }),
          _buildActionButton(
              Icons.bar_chart, AppColors.primary, 'Stats', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const StatsScreen()));
          }),
          IconButton(
            icon: Icon(Icons.logout,
                color: AppColors.textPrimary.withValues(alpha: 0.54)),
            tooltip: 'Sair',
            onPressed: () async {
              await AuthStorage.logout();
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
                  color: AppColors.textPrimary.withValues(alpha: 0.7),
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
                            color:
                                AppColors.textPrimary.withValues(alpha: 0.3)),
                        const SizedBox(height: 10),
                        Text('Você ainda não faz parte de um time.',
                            style: GoogleFonts.poppins(
                                color: AppColors.textSecondary)),
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
        icon: const Icon(Icons.flash_on, color: AppColors.textPrimary),
        label: Text('DESAFIAR',
            style: GoogleFonts.exo2(
                color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
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
    final bool isActive = teamStatus == 'A';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle),
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
            if (isActive) {
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
                        color: AppColors.info.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.shield,
                        color: isActive ? AppColors.info : AppColors.pending,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            teamName,
                            style: GoogleFonts.exo2(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            isActive ? teamCargo.toUpperCase() : 'PENDENTE',
                            style: GoogleFonts.poppins(
                                color: isActive
                                    ? AppColors.textSecondary
                                    : AppColors.pending,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    if (isActive)
                      IconButton(
                        icon: const Icon(Icons.exit_to_app,
                            color: AppColors.danger),
                        onPressed: () =>
                            _showLeaveTeamDialog(context, teamId, teamName),
                      ),
                  ],
                ),
                if (!isActive) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.success.withValues(alpha: 0.8),
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
                          child: Text("Aceitar",
                              style: GoogleFonts.poppins(
                                  color: AppColors.textPrimary)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.danger),
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
                          child: Text("Recusar",
                              style: GoogleFonts.poppins(
                                  color: AppColors.danger)),
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
          backgroundColor: AppColors.surface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Sair do Time',
              style: GoogleFonts.exo2(color: AppColors.textPrimary)),
          content: Text('Tem certeza que deseja sair de "$teamName"?',
              style:
                  GoogleFonts.poppins(color: AppColors.textPrimary.withValues(alpha: 0.7))),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar',
                  style: TextStyle(
                      color: AppColors.textPrimary.withValues(alpha: 0.54))),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: Text('SAIR',
                  style: GoogleFonts.exo2(
                      color: AppColors.danger, fontWeight: FontWeight.bold)),
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
