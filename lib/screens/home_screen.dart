import 'package:erank_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Rank'),
        backgroundColor: AppColors.background,
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Login realizado com sucesso!',
          style: TextStyle(fontSize: 24, color: AppColors.white),
        ),
      ),
    );
  }
}
