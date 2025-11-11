import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:erank_app/screens/signup_screen.dart';
import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/services/auth_service.dart'; // Importe o serviço
import 'package:erank_app/widgets/custom_form_field.dart';
import 'package:erank_app/screens/home_screen.dart';
import 'package:erank_app/widgets/primary_button.dart';
import 'package:erank_app/screens/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // CORREÇÃO: Linha removida. Não precisamos mais de uma instância.
  // final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // CORREÇÃO: Chamando o método "static" diretamente pela classe.
    final success = await AuthService.login(
      _emailController.text,
      _passwordController.text,
    );

    // Verifique se o widget ainda está na árvore de widgets antes de atualizar o estado
    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: AppColors.red,
            content: Text('E-mail ou senha inválidos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (O restante do seu método build permanece o mesmo)
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset('assets/erank_logo.png', height: 120),
                    const SizedBox(height: 20),
                    Text('Entrar no E-rank',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.exo2(
                            fontSize: 32,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 40),
                    CustomFormField(
                      controller: _emailController,
                      label: 'E-mail',
                      keyboardType: TextInputType.emailAddress,
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'E-mail é obrigatório'),
                        EmailValidator(errorText: 'Insira um e-mail válido')
                      ]).call,
                    ),
                    const SizedBox(height: 20),
                    CustomFormField(
                      controller: _passwordController,
                      label: 'Senha',
                      obscureText: true,
                      validator:
                          RequiredValidator(errorText: 'Senha é obrigatória')
                              .call,
                    ),
                    const SizedBox(height: 40),
                    PrimaryButton(
                      text: 'LOGIN',
                      isLoading: _isLoading,
                      onPressed: _loginUser,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen()),
                          );
                        },
                        child: const Text('Esqueci minha senha'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignUpScreen())),
                      child: const Text('Não tem uma conta? Cadastre-se'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
