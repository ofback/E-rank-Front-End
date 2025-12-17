import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/screens/login_screen.dart';
import 'package:erank_app/screens/profile/edit_profile_screen.dart';
import 'package:erank_app/services/auth_service.dart';
import 'package:erank_app/services/user_service.dart';
import 'package:erank_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:erank_app/screens/teams/create_team_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: Colors.transparent,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: UserService.fetchMyProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text('Erro ao carregar perfil.',
                  style: TextStyle(color: Colors.white)),
            );
          }

          final user = snapshot.data!;

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E2C).withValues(alpha: 0.90),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white24, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 25,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: AppColors.primary, width: 2),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.5),
                                  blurRadius: 20)
                            ]),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black,
                          child: Text(
                            user['nickname']?[0].toUpperCase() ?? 'U',
                            style: GoogleFonts.bevan(
                                fontSize: 40, color: AppColors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        user['nickname'] ?? 'Usuário',
                        style: GoogleFonts.exo2(
                            color: AppColors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        user['email'] ?? 'email@desconhecido.com',
                        style: GoogleFonts.poppins(
                            color: AppColors.white54, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 40),
                    PrimaryButton(
                      text: 'EDITAR PERFIL',
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfileScreen(userData: user),
                          ),
                        )
                            .then((_) {
                          setState(() {});
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      text: 'CRIAR TIME',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const CreateTeamScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      icon: const Icon(Icons.logout, color: Colors.redAccent),
                      label: Text('SAIR DA CONTA',
                          style: GoogleFonts.exo2(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold)),
                      onPressed: _logout,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
