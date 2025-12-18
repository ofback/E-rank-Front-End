import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/models/team_member.dart';
import 'package:erank_app/services/auth_storage.dart';
import 'package:erank_app/services/team_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeamDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> team;

  const TeamDetailsScreen({super.key, required this.team});

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  Future<List<TeamMember>>? _membersFuture;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    final int teamId = widget.team['id'] ?? 0;
    _membersFuture = TeamService.getTeamMembers(teamId);
    _loadUserId();
  }

  void _loadUserId() async {
    final userId = await AuthStorage.getUserId();
    if (mounted) {
      setState(() {
        _currentUserId = userId;
      });
    }
  }

  void _refresh() {
    setState(() {
      _membersFuture = TeamService.getTeamMembers(widget.team['id'] ?? 0);
    });
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C29),
      body: Stack(
        children: [
          // Background Global
          Positioned.fill(
            child: Image.asset(
              'assets/background_neon.png',
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) =>
                  Container(color: const Color(0xFF0F0C29)),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              centerTitle: true,
              title: Text(
                widget.team['nome']?.toUpperCase() ?? 'TIME',
                style: GoogleFonts.bevan(color: Colors.white, letterSpacing: 1),
              ),
            ),
            body: _membersFuture == null
                ? const Center(child: CircularProgressIndicator())
                : FutureBuilder<List<TeamMember>>(
                    future: _membersFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                            child: Text("Sem membros.",
                                style: GoogleFonts.poppins(
                                    color: Colors.white54)));
                      }

                      final members = snapshot.data!;
                      final myProfile = members.firstWhere(
                          (m) => m.userId == _currentUserId,
                          orElse: () => TeamMember(
                              userId: -1,
                              nickname: '',
                              cargo: '',
                              dataEntrada: '',
                              status: ''));

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: members.length,
                        itemBuilder: (context, index) {
                          final member = members[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E2C)
                                  .withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: member.isDono
                                    ? Colors.amber
                                    : (member.isVice
                                        ? Colors.cyan
                                        : AppColors.primary),
                                child: Text(
                                  member.nickname.isNotEmpty
                                      ? member.nickname[0].toUpperCase()
                                      : '?',
                                  style: GoogleFonts.bevan(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(
                                member.nickname,
                                style: GoogleFonts.exo2(
                                  color: member.isPendente
                                      ? Colors.white54
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                member.isPendente
                                    ? "Convite Pendente"
                                    : member.cargo.toUpperCase(),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: member.isPendente
                                      ? Colors.orange
                                      : Colors.white54,
                                ),
                              ),
                              trailing: _buildActionButtons(member, myProfile),
                            ),
                          );
                        },
                      );
                    },
                  ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.person_add, color: Colors.white),
              onPressed: () => _showAddMemberDialog(),
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildActionButtons(TeamMember target, TeamMember me) {
    if (target.userId == me.userId) return null;
    if (!me.isDono && !me.isVice) return null;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      color: const Color(0xFF1E1E2C), // Cor de fundo do menu
      onSelected: (value) {
        if (value == 'promote') _promote(target);
        if (value == 'kick') _kick(target);
      },
      itemBuilder: (context) => [
        if (me.isDono && target.isMembro && !target.isPendente)
          PopupMenuItem(
              value: 'promote',
              child: Text('Promover a Vice',
                  style: GoogleFonts.poppins(color: Colors.white))),
        if (me.isDono && target.isVice)
          PopupMenuItem(
              value: 'promote',
              child: Text('Rebaixar a Membro',
                  style: GoogleFonts.poppins(color: Colors.white))),
        if (me.isDono || (me.isVice && target.isMembro))
          PopupMenuItem(
              value: 'kick',
              child: Text('Remover',
                  style: GoogleFonts.poppins(color: Colors.redAccent))),
      ],
    );
  }

  void _promote(TeamMember member) async {
    final newRole = member.isMembro ? 'ViceLider' : 'Membro';
    try {
      await TeamService.updateRole(widget.team['id'], member.userId, newRole);
      if (mounted) _refresh();
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _kick(TeamMember member) async {
    try {
      await TeamService.removeMember(widget.team['id'], member.userId);
      if (mounted) _refresh();
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showAddMemberDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Adicionar Membro (ID)',
            style: GoogleFonts.exo2(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'ID do Usuário',
            hintStyle: const TextStyle(color: Colors.white38),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white24)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primary)),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar',
                  style: TextStyle(color: Colors.white54))),
          TextButton(
            onPressed: () async {
              final id = int.tryParse(controller.text);
              if (id != null) {
                Navigator.pop(ctx);
                try {
                  await TeamService.addMember(widget.team['id'], id);
                  if (!mounted) return;
                  _refresh();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Convite enviado!"),
                      backgroundColor: Colors.green));
                } catch (e) {
                  _showError(e.toString());
                }
              }
            },
            child: const Text('ADICIONAR',
                style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
