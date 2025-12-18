import 'package:erank_app/widgets/custom_form_field.dart';
import 'package:erank_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:erank_app/services/user_service.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final success = await UserService.updateMyProfile({
      'nickname': _nicknameController.text,
      'biografia': _biografiaController.text,
    });
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (success) Navigator.of(context).pop();
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
              title: Text('EDITAR PERFIL', style: GoogleFonts.bevan()),
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
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
                      controller: _nicknameController,
                      label: 'NICKNAME',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                    CustomFormField(
                      controller: _biografiaController,
                      label: 'BIOGRAFIA',
                      icon: Icons.description,
                      maxLines: 3,
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
            ),
          ),
        ],
      ),
    );
  }
}
