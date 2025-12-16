import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/widgets/custom_form_field.dart';
import 'package:erank_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  void _sendRecoveryEmail() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.green,
          content: Text(
              'Se o e-mail existir, uma mensagem de recuperação foi enviada.'),
        ),
      );
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Senha'),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Digite seu e-mail para recuperar sua senha.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 30),
                CustomFormField(
                  controller: _emailController,
                  label: 'E-mail',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 30),
                PrimaryButton(
                  text: 'ENVIAR',
                  isLoading: _isLoading,
                  onPressed: _sendRecoveryEmail,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
