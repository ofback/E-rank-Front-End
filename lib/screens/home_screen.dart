import 'package:flutter/material.dart';
import 'package:erank_app/services/team_service.dart'; // Importe o serviço

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _myTeamsFuture;

  // CORREÇÃO: Linha removida. Não precisamos mais de uma instância.
  // final TeamService _teamService = TeamService();

  @override
  void initState() {
    super.initState();
    _loadMyTeams();
  }

  void _loadMyTeams() {
    setState(() {
      // CORREÇÃO: Chamando o método "static" diretamente pela classe.
      _myTeamsFuture = TeamService.getMyTeams();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Rank'),
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
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _myTeamsFuture,
              builder: (context, snapshot) {
                // ... (O restante do seu FutureBuilder permanece o mesmo)
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Erro ao carregar times: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Você ainda não faz parte de um time.'));
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
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text(teamName),
                        subtitle: Text(team['cargo'] ?? 'Cargo indisponível'),
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
                // CORREÇÃO: Chamando o método "static" diretamente pela classe.
                bool success = await TeamService.leaveTeam(teamId);

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
