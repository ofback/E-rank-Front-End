import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/models/challenge.dart';
import 'package:erank_app/screens/challenges/register_result_screen.dart';
import 'package:erank_app/services/api_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background_neon.png',
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) =>
                  Container(color: AppColors.background),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('PARTIDAS ATIVAS',
                  style: GoogleFonts.bevan(color: Colors.white)),
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
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
                  return Center(
                    child: Text('Nenhuma partida ativa.',
                        style: GoogleFonts.poppins(color: Colors.white54)),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final challenge = list[index];
                    // LÓGICA RESTAURADA: Verifica se o status é 'AGUARDANDO'
                    final bool jaRegistrei = challenge.status == 'AGUARDANDO';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: ListTile(
                        title: Text(
                          challenge.desafianteNome,
                          style: GoogleFonts.exo2(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Data: ${challenge.dataHora}',
                          style: GoogleFonts.poppins(
                              color: Colors.white54, fontSize: 12),
                        ),
                        trailing: jaRegistrei
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.pending),
                                  borderRadius: BorderRadius.circular(4),
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
                                    foregroundColor: AppColors.textPrimary),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RegisterResultScreen(
                                          challenge: challenge),
                                    ),
                                  );
                                  _loadMatches();
                                },
                                child: const Text('REGISTRAR',
                                    style: TextStyle(color: Colors.white)),
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
}
