// E-rank-Front-End/lib/screens/social/tabs/friends_tab.dart
import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/services/social_service.dart';
import 'package:flutter/material.dart';

// 1. Converter para StatefulWidget para podermos carregar dados
class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  // 2. Usar um Future para buscar os amigos
  late Future<List<dynamic>> _friendsFuture;
  List<dynamic>? _friends;
  int? _loadingFriendshipId;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  void _loadFriends() {
    // 3. Chamar o serviço que já existe
    _friendsFuture = SocialService.getMyFriends();
  }

  // 4. Lógica para remover um amigo
  Future<void> _removeFriend(int friendshipId) async {
    setState(() {
      _loadingFriendshipId = friendshipId;
    });

    final success = await SocialService.declineOrRemoveFriendship(friendshipId);

    if (!mounted) return;

    setState(() {
      _loadingFriendshipId = null;
      if (success) {
        // Remove da lista local para atualizar a UI
        _friends
            ?.removeWhere((friend) => friend['friendshipId'] == friendshipId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.green,
            content: Text('Amizade removida com sucesso.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.red,
            content: Text('Erro ao remover amizade.'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 5. Usar um FutureBuilder para construir a lista
    return FutureBuilder<List<dynamic>>(
      future: _friendsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.primary));
        }

        if (snapshot.hasError) {
          return const Center(
              child: Text('Erro ao carregar amigos.',
                  style: TextStyle(color: Colors.white)));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          // Atualiza a lista local na primeira carga
          _friends ??= [];
          return const Center(
              child: Text('Você ainda não tem amigos.',
                  style: TextStyle(color: AppColors.white54)));
        }

        // Atualiza a lista local se _friends for nulo
        _friends ??= List.from(snapshot.data!);

        // 6. Construir a lista de amigos
        return ListView.builder(
          itemCount: _friends!.length,
          itemBuilder: (context, index) {
            final friend = _friends![index];
            final friendshipId = friend['friendshipId'];
            final bool isProcessing = _loadingFriendshipId == friendshipId;

            // --- CORREÇÃO AQUI ---
            // O DTO do backend (FriendDTO) envia 'nickname'
            final String nickname = friend['nickname'] ?? 'Amigo';

            return Card(
              color: Colors.white.withOpacity(0.05),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.8),
                  child: Text(
                    // Lógica para evitar erro se o nickname estiver vazio
                    nickname.isNotEmpty ? nickname[0].toUpperCase() : '?',
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
                title: Text(
                  nickname,
                  style: const TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.bold),
                ),
                trailing: isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.person_remove,
                            color: AppColors.red),
                        onPressed: () => _removeFriend(friendshipId),
                        tooltip: 'Remover amigo',
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
