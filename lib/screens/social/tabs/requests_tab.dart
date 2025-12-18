import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/services/social_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    setState(() => _loadingFriendshipId = friendshipId);

    final success = accept
        ? await SocialService.acceptFriendRequest(friendshipId)
        : await SocialService.declineOrRemoveFriendship(friendshipId);

    if (!mounted) return;

    setState(() {
      _loadingFriendshipId = null;
      if (success) {
        _requests?.removeWhere((req) => req['friendshipId'] == friendshipId);
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
        if (_requests == null && snapshot.hasData) {
          _requests = snapshot.data!;
        }

        if (_requests == null || _requests!.isEmpty) {
          return Center(
              child: Text('Nenhum convite pendente.',
                  style: GoogleFonts.poppins(color: Colors.white54)));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _requests!.length,
          itemBuilder: (context, index) {
            final request = _requests![index];
            final isProcessing =
                _loadingFriendshipId == request['friendshipId'];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 10)
                ],
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Text(
                    request['senderNickname']?[0].toUpperCase() ?? '?',
                    style: GoogleFonts.bevan(color: Colors.white),
                  ),
                ),
                title: Text(
                  request['senderNickname'] ?? 'Usuário',
                  style: GoogleFonts.exo2(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Quer ser seu amigo',
                  style:
                      GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
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
                                color: Colors.greenAccent),
                            onPressed: () =>
                                _handleRequest(request['friendshipId'], true),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel,
                                color: Colors.redAccent),
                            onPressed: () =>
                                _handleRequest(request['friendshipId'], false),
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
