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

  late Future<List<dynamic>> _friendsFuture;
  final Set<int> _selectedFriendIds = {};

  @override
  void initState() {
    super.initState();
    _friendsFuture = SocialService.getMyFriends();
  }

  Future<void> _createTeam() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _isLoading = true);
    try {
      await TeamService.createTeam(
        name: _teamNameController.text,
        description: _descriptionController.text,
        memberIds: _selectedFriendIds.toList(),
      );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C29),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/background_neon.png', fit: BoxFit.cover),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('CRIAR TIME',
                  style: GoogleFonts.bevan(color: Colors.white)),
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2C).withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomFormField(
                        controller: _teamNameController,
                        label: 'NOME DO TIME',
                        icon: Icons.group,
                        validator:
                            RequiredValidator(errorText: 'Obrigatório').call,
                      ),
                      const SizedBox(height: 20),
                      CustomFormField(
                        controller: _descriptionController,
                        label: 'DESCRIÇÃO',
                        icon: Icons.description,
                        maxLines: 3,
                        validator:
                            RequiredValidator(errorText: 'Obrigatório').call,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Convidar Amigos',
                        style: GoogleFonts.exo2(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: FutureBuilder<List<dynamic>>(
                          future: _friendsFuture,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final friends = snapshot.data!;
                            if (friends.isEmpty) {
                              return Center(
                                  child: Text("Sem amigos",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white54)));
                            }

                            return ListView.separated(
                              itemCount: friends.length,
                              separatorBuilder: (_, __) => const Divider(
                                  height: 1, color: Colors.white10),
                              itemBuilder: (context, index) {
                                final friend = friends[index];
                                final friendId = friend['userId'];
                                final isSelected =
                                    _selectedFriendIds.contains(friendId);

                                return CheckboxListTile(
                                  title: Text(friend['nickname'] ?? 'Amigo',
                                      style: GoogleFonts.exo2(
                                          color: Colors.white)),
                                  value: isSelected,
                                  onChanged: (val) {
                                    setState(() {
                                      if (val == true) {
                                        _selectedFriendIds.add(friendId);
                                      } else {
                                        _selectedFriendIds.remove(friendId);
                                      }
                                    });
                                  },
                                  activeColor: AppColors.primary,
                                  checkColor: Colors.white,
                                  side: const BorderSide(color: Colors.white54),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      PrimaryButton(
                        text: 'CRIAR E CONVIDAR',
                        isLoading: _isLoading,
                        onPressed: _createTeam,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
