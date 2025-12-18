import 'package:flutter/material.dart';
import 'package:erank_app/models/player_card.dart';
import 'package:erank_app/services/estatisticas_service.dart';
import 'package:erank_app/widgets/player_card_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  PlayerCard? _card;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final card = await EstatisticasService.getMyPlayerCard();
    if (mounted) {
      setState(() {
        _card = card;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C29),
      body: Stack(
        children: [
          Positioned.fill(
              child:
                  Image.asset('assets/background_neon.png', fit: BoxFit.cover)),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('ESTATÍSTICAS',
                  style: GoogleFonts.bevan(color: Colors.white)),
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        if (_card != null)
                          PlayerCardWidget(card: _card!)
                        else
                          const Text("Erro ao carregar card.",
                              style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 30),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Histórico Recente",
                              style: GoogleFonts.exo2(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFF1E1E2C).withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Center(
                            child: Text("Nenhuma partida recente.",
                                style:
                                    GoogleFonts.poppins(color: Colors.white54)),
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
