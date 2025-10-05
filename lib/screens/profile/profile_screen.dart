import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _logout() {
    // Lógica de logout virá aqui
    print('Logout Pressionado!');
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
