import 'package:erank_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra de Busca
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar jogadores por nickname...',
                hintStyle: const TextStyle(color: AppColors.white54),
                prefixIcon: const Icon(Icons.search, color: AppColors.white54),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                // Lógica de busca virá aqui
                print('Buscando por: $value');
              },
            ),
            const SizedBox(height: 20),
            // Área para a lista de amigos/resultados
            Expanded(
              child: Center(
                child: Text(
                  'Busque por um jogador para adicioná-lo.',
                  style: TextStyle(color: AppColors.white54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
