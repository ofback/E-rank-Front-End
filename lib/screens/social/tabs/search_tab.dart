import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/services/social_service.dart';
import 'package:erank_app/services/auth_storage.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final userId = await AuthStorage.getUserId();
    if (mounted) {
      setState(() {
        _currentUserId = userId;
      });
    }
  }

  void _searchUsers(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _searchResults = [];
    });

    final results = await SocialService.searchUsers(query);

    if (mounted) {
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    }
  }

  void _sendFriendRequest(int targetUserId) async {
    final success = await SocialService.sendFriendRequest(targetUserId);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Solicitação de amizade enviada!'),
            backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Erro ao enviar solicitação.'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: AppColors.white),
            decoration: InputDecoration(
              hintText: 'Buscar usuários...',
              hintStyle: const TextStyle(color: AppColors.white54),
              prefixIcon: const Icon(Icons.search, color: AppColors.white54),
              filled: true,
              // ignore: deprecated_member_use
              fillColor: AppColors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: _searchUsers,
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _searchResults.isEmpty
                  ? Center(
                      child: Text(
                        _hasSearched
                            ? 'Nenhum usuário encontrado.'
                            : 'Digite para buscar...',
                        style: const TextStyle(color: AppColors.white54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final user = _searchResults[index];
                        if (user['id'] == _currentUserId) {
                          return const SizedBox.shrink();
                        }

                        return ListTile(
                          leading: CircleAvatar(
                            // ignore: deprecated_member_use
                            backgroundColor: AppColors.primary.withOpacity(0.2),
                            child: Text(
                              (user['nickname'] ?? '?')[0].toUpperCase(),
                              style: const TextStyle(color: AppColors.primary),
                            ),
                          ),
                          title: Text(
                            user['nickname'] ?? 'Sem Nickname',
                            style: const TextStyle(color: AppColors.white),
                          ),
                          subtitle: Text(
                            user['nome'] ?? '',
                            style: const TextStyle(color: AppColors.white54),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.person_add,
                                color: AppColors.primary),
                            onPressed: () => _sendFriendRequest(user['id']),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
