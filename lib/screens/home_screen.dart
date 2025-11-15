// E-rank-Front-End/lib/screens/home_screen.dart
import 'package:erank_app/core/theme/app_colors.dart'; // 1. IMPORTAR AppColors
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
        // --- 3. CORREÇÃO DA BARRA AMARELA ---
        // Define a cor da AppBar para combinar com o fundo
        backgroundColor: AppColors.background,
        elevation: 0, // Remove a sombra
        // --------------------------------------
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
              // --- 4. GARANTIR QUE O TEXTO SEJA BRANCO ---
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: AppColors.white),
              // --------------------------------------------
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
                          style: const TextStyle(
                              color: AppColors.white54))); // Corrigir cor
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Você ainda não faz parte de um time.',
                          style: const TextStyle(
                              color: AppColors.white54))); // Corrigir cor
                }

                final myTeams = snapshot.data!;

                return ListView.builder(
                  itemCount: myTeams.length,
                  itemBuilder: (context, index) {
                    final team = myTeams[index];
                    final int teamId = team['id'] is int
                        ? team['id']
                        : int.parse(team['id'].toString());
                    final String teamName = team['nome'] ?? 'Nome indisponível';

                    return Card(
                      // --- 5. CORRIGIR COR DO CARD PARA O TEMA ESCURO ---
                      color: AppColors.white.withOpacity(0.05),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(teamName,
                            style: const TextStyle(
                                color: AppColors.white)), // Corrigir cor
                        subtitle: Text(team['cargo'] ?? 'Cargo indisponível',
                            style: const TextStyle(
                                color: AppColors.white54)), // Corrigir cor
                        // ----------------------------------------------------
                        trailing: IconButton(
                          icon:
                              const Icon(Icons.exit_to_app, color: Colors.red),
                          onPressed: () {
                            _showLeaveTeamDialog(context, teamId, teamName);
                          },
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
