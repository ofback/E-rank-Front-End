import 'package:erank_app/screens/login_screen.dart';
import 'package:erank_app/services/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:erank_app/navigation/main_navigator_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  Future<bool> _checkLoginStatus() async {
    final token = await AuthStorage.getToken();
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF1A1A2E),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data == true) {
          return const MainNavigatorScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
