import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
// Seus imports
import 'package:erank_app/screens/signup_screen.dart';
import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/services/auth_service.dart';
import 'package:erank_app/widgets/custom_form_field.dart';
import 'package:erank_app/widgets/primary_button.dart';
import 'package:erank_app/screens/forgot_password_screen.dart';
import 'package:erank_app/navigation/main_navigator_screen.dart';

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

  // Variáveis de controle de cor
  Color? _emailBorderColor;
  Color? _passwordBorderColor;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Lógica do E-mail: Vermelho se incompleto, Verde se completo
  void _validateEmailLive(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      if (value.isEmpty) {
        _emailBorderColor = null; // Volta ao padrão se limpar
      } else if (emailRegex.hasMatch(value)) {
        _emailBorderColor = Colors.greenAccent; // Válido
      } else {
        _emailBorderColor = Colors.redAccent; // Digitando/Inválido
      }
    });
  }

  // Lógica da Senha: Limpa o vermelho quando o usuário começa a corrigir
  void _resetPasswordColor(String value) {
    if (_passwordBorderColor != null) {
      setState(() {
        _passwordBorderColor = null; // Volta a cor padrão enquanto digita
      });
    }
  }

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await AuthService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainNavigatorScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      // REGRA: Só fica vermelho quando erra a senha (login falhou)
      setState(() {
        _passwordBorderColor = Colors.red;
        // Opcional: também pode deixar o email vermelho se quiser indicar erro geral
        // _emailBorderColor = Colors.red;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: AppColors.red,
            content: Text('E-mail ou senha inválidos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C29),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/background_neon.png',
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) =>
                  Container(color: const Color(0xFF141414)),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Título
                    Text(
                      'E-RANK',
                      style: GoogleFonts.bevan(
                          fontSize: 64,
                          color: Colors.white,
                          letterSpacing: 3.0,
                          shadows: [
                            const Shadow(
                                color: Colors.black,
                                offset: Offset(4, 4),
                                blurRadius: 10),
                            const Shadow(
                                color: Colors.blueAccent, blurRadius: 20),
                          ]),
                    ),
                    Text(
                      'Você em primeiro lugar',
                      style: GoogleFonts.exo2(
                          fontSize: 18,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                          shadows: [
                            const Shadow(
                                color: Colors.black,
                                offset: Offset(1, 1),
                                blurRadius: 2)
                          ]),
                    ),
                    const SizedBox(height: 40),

                    // Container do Formulário
                    Container(
                      constraints: const BoxConstraints(maxWidth: 450),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                          color: const Color(0xFF1E1E2C).withOpacity(0.90),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24, width: 1),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.6),
                                blurRadius: 25,
                                spreadRadius: 5)
                          ]),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Faça login',
                              style: GoogleFonts.exo2(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Entre com seus dados.',
                              style: TextStyle(color: Colors.white60),
                            ),
                            const SizedBox(height: 30),

                            // 1. EMAIL (Validação visual ativa)
                            CustomFormField(
                              controller: _emailController,
                              label: 'E-mail',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              borderColor: _emailBorderColor, // Cor dinâmica
                              onChanged:
                                  _validateEmailLive, // Checa enquanto digita
                              validator: MultiValidator([
                                RequiredValidator(errorText: 'Obrigatório'),
                                EmailValidator(errorText: 'E-mail inválido')
                              ]).call,
                            ),
                            const SizedBox(height: 20),

                            // 2. SENHA (Só fica vermelho no erro de login)
                            CustomFormField(
                              controller: _passwordController,
                              label: 'Senha',
                              icon: Icons.lock_outline,
                              isPassword: true,
                              borderColor: _passwordBorderColor, // Cor dinâmica
                              onChanged:
                                  _resetPasswordColor, // Limpa o vermelho ao digitar de novo
                              validator:
                                  RequiredValidator(errorText: 'Obrigatória')
                                      .call,
                            ),

                            const SizedBox(height: 30),
                            PrimaryButton(
                              text: 'LOGIN',
                              isLoading: _isLoading,
                              onPressed: _loginUser,
                            ),

                            // Links e Redes Sociais
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, bottom: 30.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const ForgotPasswordScreen())),
                                    child: const Text('Esqueceu a senha?',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13)),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const SignUpScreen())),
                                    child: const Text('Não possui conta',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _socialButton(Icons.g_mobiledata),
                                const SizedBox(width: 20),
                                _socialButton(Icons.apple),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(IconData icon) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }
}
