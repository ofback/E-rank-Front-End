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
  // Removemos o 'late' para evitar o crash se falhar a inicialização
  Future<List<TeamMember>>? _membersFuture;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // 1. Inicia a busca dos membros IMEDIATAMENTE (não pode ser null aqui)
    // Usamos o operador `?? 0` para garantir que se o ID vier nulo, não quebre (envia 0 e retorna vazio)
    final int teamId = widget.team['id'] ?? 0;
    _membersFuture = TeamService.getTeamMembers(teamId);

    // 2. Carrega o ID do usuário em paralelo
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

  // Para recarregar a lista (ex: após expulsar alguém)
  void _refreshMembers() {
    setState(() {
      final int teamId = widget.team['id'] ?? 0;
      _membersFuture = TeamService.getTeamMembers(teamId);
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
                      child: Text("Nenhum membro encontrado.",
                          style: TextStyle(color: Colors.white)));
                }

                final members = snapshot.data!;

                // Encontra meu perfil na lista para saber permissões (seguro contra nulos)
                final myMemberProfile = members.firstWhere(
                    (m) => m.userId == _currentUserId,
                    orElse: () => TeamMember(
                        userId: -1,
                        nickname: '',
                        cargo: 'Membro',
                        dataEntrada: ''));

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: members.length,
                  separatorBuilder: (_, __) =>
                      const Divider(color: Colors.white12),
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Text(member.nickname.isNotEmpty
                            ? member.nickname[0].toUpperCase()
                            : '?'),
                      ),
                      title: Text(member.nickname,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      subtitle: Text(member.cargo,
                          style: TextStyle(
                              color: member.isDono
                                  ? Colors.amber
                                  : (member.isVice
                                      ? Colors.blueAccent
                                      : Colors.grey))),
                      trailing: _buildActionButtons(member, myMemberProfile),
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
        if (value == 'promote') _promoteMember(target);
        if (value == 'kick') _kickMember(target);
      },
      itemBuilder: (context) => [
        if (me.isDono && target.isMembro)
          const PopupMenuItem(value: 'promote', child: Text('Promover a Vice')),
        if (me.isDono && target.isVice)
          const PopupMenuItem(
              value: 'promote', child: Text('Rebaixar a Membro')),
        if (me.isDono || (me.isVice && target.isMembro))
          const PopupMenuItem(value: 'kick', child: Text('Remover do Time')),
      ],
    );
  }

  void _promoteMember(TeamMember member) async {
    final newRole = member.isMembro ? 'ViceLider' : 'Membro';
    final success =
        await TeamService.updateRole(widget.team['id'], member.userId, newRole);
    if (success) {
      _refreshMembers();
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Cargo atualizado!")));
    }
  }

  void _kickMember(TeamMember member) async {
    final success =
        await TeamService.removeMember(widget.team['id'], member.userId);
    if (success) {
      _refreshMembers();
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Membro removido.")));
    }
  }

  void _showAddMemberDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Adicionar Membro',
            style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'ID do Usuário',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () async {
              final id = int.tryParse(controller.text);
              if (id != null) {
                Navigator.pop(ctx);
                final success =
                    await TeamService.addMember(widget.team['id'], id);
                if (success) {
                  _refreshMembers();
                  if (mounted)
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Membro adicionado!")));
                } else {
                  if (mounted)
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Erro ao adicionar.")));
                }
              }
            },
            child: const Text('Adicionar',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
