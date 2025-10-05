import 'package:erank_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: const Center(
        child: Text(
          'Página de Recuperação de Senha',
          style: TextStyle(color: AppColors.white),
        ),
      ),
    );
  }
}
