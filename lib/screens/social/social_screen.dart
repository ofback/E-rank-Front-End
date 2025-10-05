import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/services/social_service.dart';
import 'package:flutter/material.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final _searchController = TextEditingController();

  // Variáveis de estado para controlar a UI
  bool _isLoading = false;
  List<dynamic> _searchResults = [];
  bool _hasSearched = false; // Para saber se uma busca já foi feita

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Função que executa a busca
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    final results = await SocialService.searchUsers(query);

    if (!mounted) return;

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  // Função para adicionar amigo (será implementada no futuro)
  void _addFriend(int userId) {
    print('Adicionar amigo com ID: $userId');
    // Aqui chamaremos o SocialService para enviar o pedido de amizade
  }

  // Widget que constrói a lista de resultados
  Widget _buildResultsList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasSearched) {
      return const Center(
        child: Text(
          'Busque por um jogador para adicioná-lo.',
          style: TextStyle(color: AppColors.white54),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum jogador encontrado.',
          style: TextStyle(color: AppColors.white54),
        ),
      );
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        return Card(
          color: Colors.white.withOpacity(0.1),
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Text(
                user['nickname']?[0].toUpperCase() ?? '?',
                style: const TextStyle(color: AppColors.white),
              ),
            ),
            title: Text(
              user['nickname'] ?? 'Usuário desconhecido',
              style: const TextStyle(
                  color: AppColors.white, fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.person_add, color: AppColors.green),
              onPressed: () => _addFriend(user['id']),
            ),
          ),
        );
      },
    );
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
              onSubmitted:
                  _performSearch, // Chama a função de busca ao pressionar Enter
            ),
            const SizedBox(height: 20),
            // Área para a lista de amigos/resultados
            Expanded(
              child: _buildResultsList(),
            ),
          ],
        ),
      ),
    );
  }
}
