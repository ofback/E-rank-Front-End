import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:erank_app/screens/login_screen.dart';
import 'package:erank_app/services/auth_service.dart';
import 'package:erank_app/widgets/custom_form_field.dart'; // Importação adicionada

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _phoneMask = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  final _cpfMask = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

  bool _isLoading = false;
  bool _acceptMarketing = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final user = {
      'nome': _nicknameController.text,
      'nickname': _nicknameController.text,
      'email': _emailController.text,
      'senha': _passwordController.text,
      'cpf': _cpfMask.getUnmaskedText(),
      'dataNascimento': "01/01/2000",
    };

    final success = await AuthService.register(user);

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Usuário cadastrado com sucesso! Faça o login.')),
      );
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Erro ao cadastrar. O e-mail já pode existir.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: isLargeScreen
            ? Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/background_signup.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(48.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('assets/erank_logo.png', height: 200),
                            const Spacer(),
                            Text('CRIAR UMA\nCONTA',
                                style: GoogleFonts.exo2(
                                    fontSize: 64,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    height: 1.0)),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/background_signup2.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(child: _buildSignUpForm()),
                    ),
                  ),
                ],
              )
            : Center(child: _buildSignUpForm()),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 750),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5)),
              ]),
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Comece sua jornada',
                      style: GoogleFonts.poppins(
                          fontSize: 24,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Preencha seus dados para entrar no ranking.',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 30),
                  CustomFormField(
                    controller: _nicknameController,
                    label: 'NICKNAME',
                    validator:
                        RequiredValidator(errorText: 'Nickname é obrigatório')
                            .call,
                  ),
                  const SizedBox(height: 20),
                  CustomFormField(
                    controller: _emailController,
                    label: 'E-MAIL',
                    keyboardType: TextInputType.emailAddress,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'E-mail é obrigatório'),
                      EmailValidator(errorText: 'Insira um e-mail válido')
                    ]).call,
                  ),
                  const SizedBox(height: 20),
                  CustomFormField(
                    controller: _confirmEmailController,
                    label: 'CONFIRME O E-MAIL',
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) =>
                        MatchValidator(errorText: 'Os e-mails não são iguais')
                            .validateMatch(val!, _emailController.text),
                  ),
                  const SizedBox(height: 20),
                  CustomFormField(
                    controller: _cpfController,
                    label: 'CPF',
                    keyboardType: TextInputType.number,
                    inputFormatters: [_cpfMask],
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return 'CPF é obrigatório';
                      if (val.length != 14) return 'CPF inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomFormField(
                    controller: _phoneController,
                    label: 'TELEFONE',
                    keyboardType: TextInputType.phone,
                    inputFormatters: [_phoneMask],
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return 'Telefone é obrigatório';
                      if (val.length != 15) return 'Telefone inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomFormField(
                    controller: _passwordController,
                    label: 'SENHA',
                    obscureText: true,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Senha é obrigatória'),
                      MinLengthValidator(8, errorText: 'Mínimo 8 caracteres'),
                      MaxLengthValidator(20, errorText: 'Máximo 20 caracteres'),
                    ]).call,
                  ),
                  const SizedBox(height: 20),
                  CustomFormField(
                    controller: _confirmPasswordController,
                    label: 'CONFIRME A SENHA',
                    obscureText: true,
                    validator: (val) =>
                        MatchValidator(errorText: 'Senhas não coincidem')
                            .validateMatch(val!, _passwordController.text),
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                    title: const Text(
                        'Sim, permito o envio de informações e eventos.',
                        style: TextStyle(fontSize: 12)),
                    value: _acceptMarketing,
                    onChanged: (v) => setState(() => _acceptMarketing = v!),
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: const Color(0xFF7F5AF0),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7F5AF0),
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                        disabledBackgroundColor: Colors.grey.shade400,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                  strokeWidth: 3, color: Colors.white))
                          : const Icon(Icons.arrow_forward_ios,
                              color: Colors.white, size: 28),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen())),
                    child: const Text('Já possui uma conta? Faça Login'),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
