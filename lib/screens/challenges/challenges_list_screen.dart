import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/models/challenge.dart';
import 'package:erank_app/services/challenge_service.dart';
import 'package:flutter/material.dart';

class ChallengesListScreen extends StatefulWidget {
  const ChallengesListScreen({super.key});

  @override
  State<ChallengesListScreen> createState() => _ChallengesListScreenState();
}

class _ChallengesListScreenState extends State<ChallengesListScreen> {
  late Future<List<Challenge>> _futureChallenges;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _futureChallenges = ChallengeService.getPendingChallenges();
    });
  }

  void _respond(int id, bool accept) async {
    try {
      await ChallengeService.respondChallenge(id, accept);
      _refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(accept ? 'Desafio aceito!' : 'Desafio recusado.'),
          backgroundColor: accept ? Colors.green : Colors.grey,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Desafios Pendentes'),
        backgroundColor: AppColors.background,
      ),
      body: FutureBuilder<List<Challenge>>(
        future: _futureChallenges,
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
              child: Text('Nenhum desafio pendente.',
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Desafio de ${challenge.desafianteNome}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Text(
                        'Data: ${challenge.dataHora}',
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => _respond(challenge.id, false),
                            child: const Text('Recusar',
                                style: TextStyle(color: Colors.red)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary),
                            onPressed: () => _respond(challenge.id, true),
                            child: const Text('Aceitar',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      )
                    ],
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
