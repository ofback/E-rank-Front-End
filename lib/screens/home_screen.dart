// E-rank-Front-End/lib/screens/home_screen.dart
import 'package:erank_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:erank_app/services/team_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('E-Rank'),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Lógica de logout aqui
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
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Erro ao carregar times: ${snapshot.error}',
                          style: const TextStyle(color: AppColors.white54)));
                } else if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Você ainda não faz parte de um time.',
                          style: const TextStyle(color: AppColors.white54)));
                }

                final myTeams = snapshot.data!;

                return ListView.builder(
                  itemCount: myTeams.length,
                  itemBuilder: (context, index) {
                    final team = myTeams[index];

                    // --- CORREÇÃO AQUI: Usando as chaves do MyTeamDTO.java ---

                    // 1. 'id' virou 'teamId'
                    final int teamId =
                        int.tryParse(team['teamId'].toString()) ?? 0;

                    // 2. 'nome' virou 'teamName'
                    final String teamName =
                        team['teamName'] ?? 'Nome indisponível';

                    // 3. 'cargo' virou 'userRole'
                    final String teamCargo =
                        team['userRole'] ?? 'Cargo indisponível';

                    return Card(
                      color: AppColors.white.withOpacity(0.05),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    teamName,
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    teamCargo,
                                    style: const TextStyle(
                                      color: AppColors.white54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.exit_to_app,
                                  color: Colors.red),
                              onPressed: () {
                                if (teamId != 0) {
                                  _showLeaveTeamDialog(
                                      context, teamId, teamName);
                                }
                              },
                            ),
                          ],
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
    );
  }

  void _showLeaveTeamDialog(BuildContext context, int teamId, String teamName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sair do Time'),
          content:
              Text('Você tem certeza que deseja sair do time "$teamName"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sair', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                bool success = await TeamService.leaveTeam(teamId);

                if (!context.mounted) return;
                Navigator.of(context).pop();

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Você saiu do time "$teamName"!')),
                  );
                  _loadMyTeams();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Erro ao tentar sair do time.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
