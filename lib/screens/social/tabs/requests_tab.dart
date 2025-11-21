import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/services/social_service.dart';
import 'package:flutter/material.dart';

class RequestsTab extends StatefulWidget {
  const RequestsTab({super.key});

  @override
  State<RequestsTab> createState() => _RequestsTabState();
}

class _RequestsTabState extends State<RequestsTab> {
  late Future<List<dynamic>> _requestsFuture;
  List<dynamic>? _requests;
  int? _loadingFriendshipId;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    _requestsFuture = SocialService.getFriendRequests();
  }

  Future<void> _handleRequest(int friendshipId, bool accept) async {
    setState(() {
      _loadingFriendshipId = friendshipId;
    });

    final success = accept
        ? await SocialService.acceptFriendRequest(friendshipId)
        : await SocialService.declineOrRemoveFriendship(friendshipId);

    if (!mounted) return;

    setState(() {
      _loadingFriendshipId = null;
      if (success) {
        _requests?.removeWhere((req) => req['friendshipId'] == friendshipId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.green,
            content:
                Text('Convite ${accept ? "aceito" : "recusado"} com sucesso!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.red,
            content: Text('Ocorreu um erro. Tente novamente.'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _requestsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(
              child: Text('Erro ao carregar convites.',
                  style: TextStyle(color: AppColors.white)));
        }

        if (_requests == null && snapshot.hasData) {
          _requests = snapshot.data!;
        }

        if (_requests == null || _requests!.isEmpty) {
          return const Center(
              child: Text('Nenhum convite pendente.',
                  style: TextStyle(color: AppColors.white54)));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _requests!.length,
          itemBuilder: (context, index) {
            final request = _requests![index];
            final isProcessing =
                _loadingFriendshipId == request['friendshipId'];

            return Card(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.05),
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  // ignore: deprecated_member_use
                  backgroundColor: AppColors.primary.withOpacity(0.8),
                  child: Text(
                    request['senderNickname']?[0].toUpperCase() ?? '?',
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
                title: Text(
                  request['senderNickname'] ?? 'Usuário',
                  style: const TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Enviou um pedido de amizade',
                  style: TextStyle(color: AppColors.white54),
                ),
                trailing: isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check_circle,
                                color: AppColors.green),
                            onPressed: () =>
                                _handleRequest(request['friendshipId'], true),
                            tooltip: 'Aceitar',
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.cancel, color: AppColors.red),
                            onPressed: () =>
                                _handleRequest(request['friendshipId'], false),
                            tooltip: 'Recusar',
                          ),
                        ],
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
