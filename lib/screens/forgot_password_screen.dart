import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:erank_app/widgets/custom_form_field.dart';
import 'package:erank_app/widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Color? _emailBorderColor;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmailLive(String value) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    setState(() {
      if (value.isEmpty) {
        _emailBorderColor = null;
      } else if (emailRegex.hasMatch(value)) {
        _emailBorderColor = Colors.greenAccent;
      } else {
        _emailBorderColor = Colors.redAccent;
      }
    });
  }

  void _sendRecoveryEmail() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content:
              Text('Se o e-mail existir, enviamos um link de recuperação.'),
        ),
      );

      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C29),
      body: Stack(
        children: [
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
                    Text(
                      'E-RANK',
                      style: GoogleFonts.bevan(
                          fontSize: 54,
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
                    const SizedBox(height: 10),
                    Text(
                      'Recuperar Acesso',
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
                    Container(
                      constraints: const BoxConstraints(maxWidth: 450),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                          color:
                              const Color(0xFF1E1E2C).withValues(alpha: 0.90),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.6),
                              blurRadius: 25,
                              spreadRadius: 5,
                            )
                          ]),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Esqueceu a senha?',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.exo2(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Digite seu e-mail cadastrado e enviaremos um link para você.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white60,
                              ),
                            ),
                            const SizedBox(height: 30),
                            CustomFormField(
                              controller: _emailController,
                              label: 'E-MAIL',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              borderColor: _emailBorderColor,
                              onChanged: _validateEmailLive,
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: 'O e-mail é obrigatório'),
                                EmailValidator(
                                    errorText: 'Insira um e-mail válido'),
                              ]).call,
                            ),
                            const SizedBox(height: 30),
                            PrimaryButton(
                              text: 'ENVIAR RECUPERAÇÃO',
                              isLoading: _isLoading,
                              onPressed: _sendRecoveryEmail,
                            ),
                            const SizedBox(height: 20),
                            TextButton.icon(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white70, size: 16),
                              label: const Text(
                                'Voltar para o Login',
                                style: TextStyle(color: Colors.white70),
                              ),
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
}
