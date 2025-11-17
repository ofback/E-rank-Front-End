import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/screens/teams/team_details_screen.dart'; // Importante!
import 'package:flutter/material.dart';
import 'package:erank_app/services/team_service.dart';
import 'package:erank_app/services/auth_storage.dart'; // Necessário para pegar o ID do usuário ao sair
import 'package:google_fonts/google_fonts.dart';

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
              // Implemente seu logout aqui
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
                          style: TextStyle(color: AppColors.white54)));
                }

                final myTeams = snapshot.data!;

                return ListView.builder(
                  itemCount: myTeams.length,
                  itemBuilder: (context, index) {
                    final team = myTeams[index];

                    // --- CHAVES CORRIGIDAS (Java DTO padrão) ---
                    final int teamId = team['id'] ?? 0;
                    final String teamName = team['nome'] ?? 'Sem Nome';
                    final String teamCargo = team['cargo'] ?? 'Membro';
                    final String teamStatus = team['status'] ?? 'P';

                    return Card(
                      color: AppColors.surface, // Usando cor do tema
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),

                      // --- HABILITA O CLIQUE ---
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TeamDetailsScreen(team: team),
                            ),
                          ).then((_) =>
                              _loadMyTeams()); // Recarrega ao voltar (caso tenha saído)
                        },
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
                                      style: GoogleFonts.inter(
                                        color: AppColors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Cargo: $teamCargo',
                                      style: const TextStyle(
                                          color: AppColors
                                              .primary, // Destaca o cargo
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'Status: ${teamStatus == 'A' ? 'Ativo' : 'Pendente'}',
                                      style: const TextStyle(
                                        color: AppColors.white54,
                                        fontSize: 12,
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
          backgroundColor: AppColors.surface,
          title:
              const Text('Sair do Time', style: TextStyle(color: Colors.white)),
          content: Text('Você tem certeza que deseja sair do time "$teamName"?',
              style: const TextStyle(color: Colors.white70)),
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
                // Busca o ID do usuário logado para passar ao endpoint
                final userId = await AuthStorage.getUserId();
                if (userId == null) return;

                bool success = await TeamService.removeMember(teamId, userId);

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
