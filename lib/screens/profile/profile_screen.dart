import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/screens/login_screen.dart';
import 'package:erank_app/screens/profile/edit_profile_screen.dart';
import 'package:erank_app/services/auth_service.dart';
import 'package:erank_app/services/user_service.dart';
import 'package:erank_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:erank_app/screens/teams/create_team_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: UserService.fetchMyProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                'Erro ao carregar perfil.',
                style: TextStyle(color: AppColors.white),
              ),
            );
          }

          final user = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    user['nickname']?[0].toUpperCase() ?? 'U',
                    style:
                        const TextStyle(fontSize: 40, color: AppColors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    user['nickname'] ?? 'Usuário',
                    style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    user['email'] ?? 'email@desconhecido.com',
                    style:
                        const TextStyle(color: AppColors.white54, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 50),
                PrimaryButton(
                  text: 'EDITAR PERFIL',
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(userData: user),
                      ),
                    )
                        .then((_) {
                      // Este código executa quando a tela de edição é fechada.
                      // Chamar setState() força o FutureBuilder a rodar novamente.
                      setState(() {});
                    });
                  },
                ),
                PrimaryButton(
                  text: 'CRIAR TIME',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const CreateTeamScreen()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  text: 'SAIR',
                  onPressed: _logout,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
