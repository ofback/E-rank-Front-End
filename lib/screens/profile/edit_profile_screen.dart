import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/widgets/custom_form_field.dart';
import 'package:erank_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';

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

  void _saveProfile() {
    // Lógica para salvar será implementada aqui
    print('Salvar perfil!');
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
            ),
            const SizedBox(height: 20),
            CustomFormField(
              controller: _biografiaController,
              label: 'Biografia',
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
