// E-rank-Front-End/lib/navigation/auth_wrapper.dart
import 'package:erank_app/screens/home_screen.dart';
import 'package:erank_app/screens/login_screen.dart';
import 'package:erank_app/services/auth_storage.dart';
import 'package:flutter/material.dart';

// Import da nossa nova tela de navegação
import 'package:erank_app/navigation/main_navigator_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  Future<bool> _checkLoginStatus() async {
    // Verifica se existe um token salvo
    final token = await AuthStorage.getToken();
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        // Enquanto verifica, mostra uma tela de loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF1A1A2E),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Se o snapshot tem dado e o valor é true (está logado)
        if (snapshot.hasData && snapshot.data == true) {
          // --- ESTA É A MUDANÇA IMPORTANTE ---
          // Antes era: return const HomeScreen();
          return const MainNavigatorScreen();
        }

        // Caso contrário, vai para a tela de Login
        return const LoginScreen();
      },
    );
  }
}
