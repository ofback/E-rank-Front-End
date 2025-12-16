import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/screens/challenges/create_challenge_screen.dart';
import 'package:erank_app/services/social_service.dart';
import 'package:flutter/material.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  late Future<List<dynamic>> _friendsFuture;

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  void _loadFriends() {
    setState(() {
      _friendsFuture = SocialService.getMyFriends();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _friendsFuture,
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

        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: friends.length,
          separatorBuilder: (context, index) =>
              const Divider(color: Colors.white10),
          itemBuilder: (context, index) {
            final friend = friends[index];

            final int friendUserId = friend['userId'] ?? 0;

            final int friendshipId =
                friend['friendshipId'] ?? friend['id'] ?? 0;

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                child: Text(
                  (friend['nickname'] ?? '?')[0].toUpperCase(),
                  style: const TextStyle(color: AppColors.primary),
                ),
              ),
              title: Text(
                friend['nickname'] ?? 'Sem Nickname',
                style: const TextStyle(color: AppColors.white),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Desafiar',
                    icon: const Icon(Icons.flash_on, color: Colors.amber),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateChallengeScreen(
                            initialFriendId: friendUserId,
                          ),
                        ),
                      );
                    },
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: AppColors.white54),
                    onSelected: (value) async {
                      if (value == 'remove') {
                        final success =
                            await SocialService.declineOrRemoveFriendship(
                                friendshipId);
                        if (success) {
                          _loadFriends();
                        }
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'remove',
                        child: Text('Desfazer Amizade',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
