import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/screens/challenges/create_challenge_screen.dart';
import 'package:erank_app/services/social_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          return Center(
            child: Text(
              'Você ainda não tem amigos adicionados.',
              style: GoogleFonts.poppins(color: Colors.white54),
            ),
          );
        }

        final friends = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            final int friendUserId = friend['userId'] ?? 0;
            final int friendshipId =
                friend['friendshipId'] ?? friend['id'] ?? 0;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C).withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                  child: Text(
                    (friend['nickname'] ?? '?')[0].toUpperCase(),
                    style: GoogleFonts.bevan(color: AppColors.primary),
                  ),
                ),
                title: Text(
                  friend['nickname'] ?? 'Sem Nickname',
                  style: GoogleFonts.exo2(
                      color: Colors.white, fontWeight: FontWeight.bold),
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
                      icon: const Icon(Icons.more_vert, color: Colors.white54),
                      color: const Color(0xFF1E1E2C),
                      onSelected: (value) async {
                        if (value == 'remove') {
                          final success =
                              await SocialService.declineOrRemoveFriendship(
                                  friendshipId);
                          if (success) _loadFriends();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'remove',
                          child: Text('Desfazer Amizade',
                              style: GoogleFonts.exo2(color: Colors.redAccent)),
                        ),
                      ],
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
