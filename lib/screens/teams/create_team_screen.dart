import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/services/social_service.dart';
import 'package:erank_app/widgets/custom_form_field.dart';
import 'package:erank_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erank_app/services/team_service.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  // Novos estados para gerenciar a lista de amigos e a seleção
  late Future<List<dynamic>> _friendsFuture;
  final Set<int> _selectedFriendIds = {};

  @override
  void initState() {
    super.initState();
    // Busca a lista de amigos ao iniciar a tela
    _friendsFuture = SocialService.getMyFriends();
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createTeam() async {
    // Transforme em async
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    // Chama o serviço com todas as informações necessárias
    final success = await TeamService.createTeam(
      name: _teamNameController.text,
      description: _descriptionController.text,
      memberIds: _selectedFriendIds.toList(), // Converte o Set para uma List
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.green,
          content: Text('Time criado e convites enviados com sucesso!'),
        ),
      );
      // Volta para a tela de perfil
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.red,
          content: Text('Erro ao criar o time. Tente novamente.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Criar Novo Time'),
        backgroundColor: AppColors.background,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Defina a identidade da sua equipe',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.white54,
                ),
              ),
              const SizedBox(height: 40),
              CustomFormField(
                controller: _teamNameController,
                label: 'Nome do Time',
                validator:
                    RequiredValidator(errorText: 'O nome do time é obrigatório')
                        .call,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                style: const TextStyle(color: AppColors.black87),
                decoration: InputDecoration(
                  labelText: 'Descrição do Time',
                  labelStyle: const TextStyle(
                    color: AppColors.greyShade600,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                validator:
                    RequiredValidator(errorText: 'A descrição é obrigatória')
                        .call,
              ),
              const SizedBox(height: 40),

              // --- SEÇÃO DE CONVIDAR AMIGOS ---
              _buildFriendsInviteSection(),

              const SizedBox(height: 40),
              PrimaryButton(
                text: 'CRIAR E CONVIDAR',
                isLoading: _isLoading,
                onPressed: _createTeam,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendsInviteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Convidar Amigos',
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 200, // Altura fixa para a lista de amigos
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FutureBuilder<List<dynamic>>(
            future: _friendsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return const Center(
                  child: Text('Erro ao carregar amigos.',
                      style: TextStyle(color: AppColors.white54)),
                );
              }
              final friends = snapshot.data!;
              if (friends.isEmpty) {
                return const Center(
                  child: Text('Você não tem amigos para convidar.',
                      style: TextStyle(color: AppColors.white54)),
                );
              }

              return ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final friend = friends[index];
                  final friendId = friend['userId'];
                  final isSelected = _selectedFriendIds.contains(friendId);

                  return CheckboxListTile(
                    title: Text(friend['nickname'] ?? 'Amigo',
                        style: const TextStyle(color: AppColors.white)),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedFriendIds.add(friendId);
                        } else {
                          _selectedFriendIds.remove(friendId);
                        }
                      });
                    },
                    activeColor: AppColors.primary,
                    checkColor: AppColors.white,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
