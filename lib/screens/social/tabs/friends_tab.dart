import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/services/social_service.dart';
import 'package:flutter/material.dart';

class FriendsTab extends StatelessWidget {
  const FriendsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: SocialService.getMyFriends(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Você ainda não tem amigos adicionados.',
              style: TextStyle(color: AppColors.white54),
            ),
          );
        }

        final friends = snapshot.data!;

        return ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: Text(
                  (friend['nickname'] ?? '?')[0].toUpperCase(),
                  style: const TextStyle(color: AppColors.primary),
                ),
              ),
              title: Text(
                friend['nickname'] ?? 'Sem Nome',
                style: const TextStyle(color: AppColors.white),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert, color: AppColors.white54),
                onPressed: () {},
              ),
            );
          },
        );
      },
    );
  }
}
