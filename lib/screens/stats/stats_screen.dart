import 'package:flutter/material.dart';
import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/models/player_card.dart';
import 'package:erank_app/services/estatisticas_service.dart';
import 'package:erank_app/widgets/player_card_widget.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Estatísticas Consolidadas'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (_card != null)
                    Center(child: PlayerCardWidget(card: _card!))
                  else
                    const Text("Não foi possível carregar a carta.",
                        style: TextStyle(color: Colors.white)),
                  const SizedBox(height: 30),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Histórico Recente",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Nenhuma partida recente encontrada.",
                      style: TextStyle(color: Colors.white54),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
