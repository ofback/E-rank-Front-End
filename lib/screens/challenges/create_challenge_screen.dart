import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/models/game.dart';
import 'package:erank_app/services/challenge_service.dart';
import 'package:erank_app/services/game_service.dart';
import 'package:erank_app/services/social_service.dart';
import 'package:erank_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class CreateChallengeScreen extends StatefulWidget {
  final int? initialFriendId;

  const CreateChallengeScreen({super.key, this.initialFriendId});

  @override
  State<CreateChallengeScreen> createState() => _CreateChallengeScreenState();
}

class _CreateChallengeScreenState extends State<CreateChallengeScreen> {
  bool _isLoading = false;
  List<dynamic> _friends = [];
  List<Game> _games = [];

  int? _selectedFriendId;
  int? _selectedGameId;

  @override
  void initState() {
    super.initState();
    _selectedFriendId = widget.initialFriendId;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final friends = await SocialService.getMyFriends();
      final games = await GameService.getGames();
      if (mounted) {
        setState(() {
          _friends = friends;
          _games = games;

          if (_selectedFriendId != null) {
            final friendExists = _friends
                .any((f) => (f['userId'] ?? f['id']) == _selectedFriendId);
            if (!friendExists) {
              _selectedFriendId = null;
            }
          }
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _submit() async {
    if (_selectedFriendId == null || _selectedGameId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione um amigo e um jogo.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ChallengeService.createChallenge(
          _selectedFriendId!, _selectedGameId!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Desafio enviado com sucesso!'),
            backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title:
            const Text('Novo Desafio', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.background,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading && _friends.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Contra quem?',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    initialValue: _selectedFriendId,
                    dropdownColor: AppColors.surface,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    hint: const Text('Selecione um amigo',
                        style: TextStyle(color: Colors.white54)),
                    items: _friends.map((f) {
                      return DropdownMenuItem<int>(
                        value: f['userId'] ?? f['id'],
                        child: Text(f['nickname'] ?? 'Sem nome'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedFriendId = val),
                  ),
                  const SizedBox(height: 30),
                  const Text('Qual jogo?',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    initialValue: _selectedGameId,
                    dropdownColor: AppColors.surface,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    hint: const Text('Selecione o jogo',
                        style: TextStyle(color: Colors.white54)),
                    items: _games.map((g) {
                      return DropdownMenuItem<int>(
                        value: g.id,
                        child: Text(g.nome),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedGameId = val),
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: 'DESAFIAR',
                    onPressed: _submit,
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
    );
  }
}
