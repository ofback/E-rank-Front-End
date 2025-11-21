import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/screens/challenges/active_matches_screen.dart'; // IMPORT NOVO
import 'package:erank_app/screens/challenges/challenges_list_screen.dart';
import 'package:erank_app/screens/challenges/create_challenge_screen.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('E-Rank', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // 1. Botão de Desafios Pendentes (Convites recebidos)
          IconButton(
            icon: const Icon(Icons.sports_kabaddi, color: Colors.white),
            tooltip: 'Desafios Pendentes',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChallengesListScreen()),
              );
            },
          ),
          // 2. NOVO: Botão de Partidas Ativas (Registrar Resultado)
          IconButton(
            icon: const Icon(Icons.sports_esports, color: Colors.white),
            tooltip: 'Minhas Partidas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ActiveMatchesScreen()),
              );
            },
          ),
          // 3. Logout
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthStorage.logout();
              // Adicione aqui a navegação de volta para login se necessário
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Meus Times',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: AppColors.white),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _myTeamsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Você ainda não faz parte de um time.',
                          style: TextStyle(color: AppColors.white54)));
                }

                final myTeams = snapshot.data!;

                return ListView.builder(
                  itemCount: myTeams.length,
                  itemBuilder: (context, index) {
                    final team = myTeams[index];
                    final int teamId = team['id'] ?? 0;
                    final String teamName = team['nome'] ?? 'Sem Nome';
                    final String teamCargo = team['cargo'] ?? 'Membro';
                    final String teamStatus = team['status'] ?? 'P';

                    return Card(
                      color: AppColors.surface,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (teamStatus == 'A') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TeamDetailsScreen(team: team),
                              ),
                            ).then((_) => _loadMyTeams());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Aceite o convite primeiro.")),
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      teamName,
                                      style: GoogleFonts.inter(
                                        color: AppColors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (teamStatus == 'A')
                                    IconButton(
                                      icon: const Icon(Icons.exit_to_app,
                                          color: Colors.red),
                                      onPressed: () => _showLeaveTeamDialog(
                                          context, teamId, teamName),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (teamStatus == 'A') ...[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Cargo: $teamCargo',
                                    style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ] else ...[
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Convite Pendente',
                                      style: TextStyle(color: Colors.orange)),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green),
                                        onPressed: () async {
                                          try {
                                            await TeamService.respondInvite(
                                                teamId, true);
                                            _loadMyTeams();
                                          } catch (e) {
                                            _showError(e.toString());
                                          }
                                        },
                                        child: const Text("Aceitar",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                                color: Colors.red)),
                                        onPressed: () async {
                                          try {
                                            await TeamService.respondInvite(
                                                teamId, false);
                                            _loadMyTeams();
                                          } catch (e) {
                                            _showError(e.toString());
                                          }
                                        },
                                        child: const Text("Recusar",
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),
                    );
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
        icon: const Icon(Icons.flash_on, color: Colors.white),
        label: const Text('Desafiar', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showLeaveTeamDialog(BuildContext context, int teamId, String teamName) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title:
              const Text('Sair do Time', style: TextStyle(color: Colors.white)),
          content: Text('Sair de "$teamName"?',
              style: const TextStyle(color: Colors.white70)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text('Sair', style: TextStyle(color: Colors.red)),
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
                  if (mounted) {
                    _showError('Erro ao sair do time: $e');
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
