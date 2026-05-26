import 'package:flutter/material.dart';
import 'package:erank_app/core/theme/app_theme.dart';
import 'package:erank_app/navigation/auth_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Rank',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const AuthWrapper(),
    );
  }
}
