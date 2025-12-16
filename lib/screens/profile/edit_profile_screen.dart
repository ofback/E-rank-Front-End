import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/widgets/custom_form_field.dart';
import 'package:erank_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:erank_app/services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfileScreen({super.key, required this.userData});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nicknameController;
  late final TextEditingController _biografiaController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nicknameController =
        TextEditingController(text: widget.userData['nickname'] ?? '');
    _biografiaController =
        TextEditingController(text: widget.userData['biografia'] ?? '');
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _biografiaController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    final profileData = {
      'nickname': _nicknameController.text,
      'biografia': _biografiaController.text,
    };

    final success = await UserService.updateMyProfile(profileData);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.green,
          content: Text('Perfil atualizado com sucesso!'),
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.red,
          content: Text('Erro ao atualizar o perfil. Tente novamente.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomFormField(
              controller: _nicknameController,
              label: 'Nickname',
              icon: Icons.person,
            ),
            const SizedBox(height: 20),
            CustomFormField(
              controller: _biografiaController,
              label: 'Biografia',
              icon: Icons.description,
            ),
            const SizedBox(height: 40),
            PrimaryButton(
              text: 'SALVAR ALTERAÇÕES',
              isLoading: _isLoading,
              onPressed: _saveProfile,
            ),
          ],
        ),
      ),
    );
  }
}
