import 'package:erank_app/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/navigation/auth_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-rank',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
        primaryColor: AppColors.primary,
      ),
      home: const AuthWrapper(), // Nossa tela de cadastro é a tela inicial
    );
  }
}
