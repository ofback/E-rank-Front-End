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
  bool _hasSearched = false;

  // Novas variáveis para controlar o estado dos botões
  final Set<int> _pendingRequestIds =
      {}; // Guarda IDs de quem já recebeu convite
  int? _loadingUserId; // Guarda o ID do usuário cujo botão está carregando

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

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

  // Lógica para enviar o pedido de amizade
  Future<void> _addFriend(int userId) async {
    setState(() {
      _loadingUserId = userId; // Ativa o loading para este usuário
    });

    final success = await SocialService.sendFriendRequest(userId);

    if (!mounted) return;

    setState(() {
      _loadingUserId = null; // Desativa o loading
      if (success) {
        _pendingRequestIds.add(userId); // Marca que o convite foi enviado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.green,
            content: Text('Pedido de amizade enviado!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.red,
            content: Text('Não foi possível enviar o pedido. Tente novamente.'),
          ),
        );
      }
    });
  }

  // Widget que decide qual ícone mostrar (loading, enviado, ou adicionar)
  Widget _buildTrailingWidget(int userId) {
    if (_loadingUserId == userId) {
      return const SizedBox(
        width: 24,
        height: 24,
        child:
            CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
      );
    }
    if (_pendingRequestIds.contains(userId)) {
      return const Icon(Icons.check_circle,
          color: AppColors.green, tooltip: 'Pedido enviado');
    }
    return IconButton(
      icon:
          const Icon(Icons.person_add_alt_1_rounded, color: AppColors.primary),
      onPressed: () => _addFriend(userId),
      tooltip: 'Adicionar amigo',
    );
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
          color: Colors.white.withOpacity(0.05),
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
            trailing: _buildTrailingWidget(user['id']),
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
              onSubmitted: _performSearch,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildResultsList(),
            ),
          ],
        ),
      ),
    );
  }
}
