import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:erank_app/services/auth_service.dart';
import 'package:erank_app/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _logout() async {
    // Chama o serviço de autenticação para limpar os dados salvos
    await AuthService.logout();

    // Garante que não vamos tentar navegar se o widget já foi removido da tela
    if (!mounted) return;

    // Navega para a LoginScreen e remove todas as telas anteriores da pilha.
    // Isso impede que o usuário use o botão "voltar" do navegador/app para retornar à HomeScreen.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                'Página de Perfil',
                style: TextStyle(color: AppColors.white, fontSize: 24),
              ),
            ),
            const SizedBox(height: 50),
            PrimaryButton(
              text: 'SAIR',
              onPressed: _logout,
              // Estilo um pouco diferente para uma ação secundária/destrutiva
              // Vamos criar um novo estilo para o botão depois, por enquanto usamos o primário.
            ),
          ],
        ),
      ),
    );
  }
}
