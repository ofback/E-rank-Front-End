import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/models/team_member.dart';
import 'package:erank_app/services/auth_storage.dart';
import 'package:erank_app/services/team_service.dart';
import 'package:flutter/material.dart';

class TeamDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> team;

  const TeamDetailsScreen({super.key, required this.team});

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {
  Future<List<TeamMember>>? _membersFuture; // Removido 'late' para evitar crash
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(widget.team['nome'] ?? 'Time',
            style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
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
                  return const Center(
                      child: Text("Sem membros.",
                          style: TextStyle(color: Colors.white)));
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

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: members.length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: Colors.white12),
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Text(member.nickname.isNotEmpty
                            ? member.nickname[0].toUpperCase()
                            : '?'),
                      ),
                      title: Text(member.nickname,
                          style: TextStyle(
                              color: member.isPendente
                                  ? Colors.white54
                                  : Colors.white,
                              fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          member.isPendente ? "Convite Pendente" : member.cargo,
                          style: TextStyle(
                              color: member.isPendente
                                  ? Colors.orange
                                  : (member.isDono
                                      ? Colors.amber
                                      : Colors.blueAccent))),
                      trailing: _buildActionButtons(member, myProfile),
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
    );
  }

  Widget? _buildActionButtons(TeamMember target, TeamMember me) {
    if (target.userId == me.userId) return null;
    if (!me.isDono && !me.isVice) return null;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (value) {
        if (value == 'promote') _promote(target);
        if (value == 'kick') _kick(target);
      },
      itemBuilder: (context) => [
        if (me.isDono && target.isMembro && !target.isPendente)
          const PopupMenuItem(value: 'promote', child: Text('Promover a Vice')),
        if (me.isDono && target.isVice)
          const PopupMenuItem(
              value: 'promote', child: Text('Rebaixar a Membro')),
        if (me.isDono || (me.isVice && target.isMembro))
          const PopupMenuItem(value: 'kick', child: Text('Remover')),
      ],
    );
  }

  void _promote(TeamMember member) async {
    final newRole = member.isMembro ? 'ViceLider' : 'Membro';
    if (await TeamService.updateRole(
        widget.team['id'], member.userId, newRole)) {
      _refresh();
    }
  }

  void _kick(TeamMember member) async {
    if (await TeamService.removeMember(widget.team['id'], member.userId)) {
      _refresh();
    }
  }

  void _showAddMemberDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Adicionar Membro (ID)',
            style: TextStyle(color: Colors.white)),
        content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
                hintText: 'ID', hintStyle: TextStyle(color: Colors.white54))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              final id = int.tryParse(controller.text);
              if (id != null) {
                Navigator.pop(ctx);
                await TeamService.addMember(widget.team['id'], id);
                _refresh();
              }
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }
}
