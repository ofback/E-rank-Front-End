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

  @override
  void initState() {
    super.initState();
    _requestsFuture = SocialService.getFriendRequests();
  }

  void _acceptRequest(int friendshipId) {
    // Lógica para aceitar o pedido virá aqui
    print('Aceitar pedido: $friendshipId');
  }

  void _declineRequest(int friendshipId) {
    // Lógica para recusar o pedido virá aqui
    print('Recusar pedido: $friendshipId');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _requestsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(
              child: Text('Erro ao carregar convites.',
                  style: TextStyle(color: AppColors.white)));
        }
        final requests = snapshot.data!;
        if (requests.isEmpty) {
          return const Center(
              child: Text('Nenhum convite pendente.',
                  style: TextStyle(color: AppColors.white54)));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return Card(
              color: Colors.white.withOpacity(0.05),
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_circle,
                          color: AppColors.green),
                      onPressed: () => _acceptRequest(request['friendshipId']),
                      tooltip: 'Aceitar',
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: AppColors.red),
                      onPressed: () => _declineRequest(request['friendshipId']),
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
