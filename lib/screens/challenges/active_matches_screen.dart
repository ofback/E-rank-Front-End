import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/models/challenge.dart';
import 'package:erank_app/screens/challenges/register_result_screen.dart';
import 'package:erank_app/services/api_client.dart';
import 'package:flutter/material.dart';

class ActiveMatchesScreen extends StatefulWidget {
  const ActiveMatchesScreen({super.key});

  @override
  State<ActiveMatchesScreen> createState() => _ActiveMatchesScreenState();
}

class _ActiveMatchesScreenState extends State<ActiveMatchesScreen> {
  late Future<List<Challenge>> _matchesFuture;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  void _loadMatches() {
    setState(() {
      _matchesFuture = _fetchAcceptedChallenges();
    });
  }

  Future<List<Challenge>> _fetchAcceptedChallenges() async {
    final response = await ApiClient.get('/desafios/aceitos');
    final data = ApiClient.handleResponse(response);
    return (data as List).map((json) => Challenge.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Partidas Ativas'),
        backgroundColor: AppColors.background,
      ),
      body: FutureBuilder<List<Challenge>>(
        future: _matchesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text('Erro: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red)));
          }
          final list = snapshot.data ?? [];

          if (list.isEmpty) {
            return const Center(
              child: Text('Nenhuma partida ativa no momento.',
                  style: TextStyle(color: Colors.white54)),
            );
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final challenge = list[index];
              return Card(
                color: AppColors.surface,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    // CORREÇÃO: Removido '${...}'
                    challenge.desafianteNome,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Data: ${challenge.dataHora}',
                    style: const TextStyle(color: Colors.white54),
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary),
                    child: const Text('Registrar',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RegisterResultScreen(challenge: challenge),
                        ),
                      );
                      _loadMatches();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
