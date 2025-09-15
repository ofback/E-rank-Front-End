import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:erank_app/screens/login_screen.dart';
import 'package:erank_app/services/local_user_service.dart';

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

  final _phoneMask = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  final _cpfMask = MaskTextInputFormatter(mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

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
      'telefone': _phoneMask.getUnmaskedText(),
    };

    final success = await LocalUserService.registerUser(user);

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.green, content: Text('Usuário cadastrado com sucesso!')),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.red, content: Text('Usuário já existe!')),
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
                                    fontSize: 64, color: Colors.white, fontWeight: FontWeight.bold, height: 1.0)),
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
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5)),
          ]),
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text('Comece sua jornada',
                  style: GoogleFonts.poppins(fontSize: 24, color: Colors.black87, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Preencha seus dados para entrar no ranking.',
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 30),
              TextFormField(
                controller: _nicknameController,
                decoration: _buildInputDecoration('NICKNAME', isWhiteBackground: true),
                validator: RequiredValidator(errorText: 'Nickname é obrigatório').call,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: _buildInputDecoration('E-MAIL', isWhiteBackground: true),
                keyboardType: TextInputType.emailAddress,
                validator: MultiValidator([
                  RequiredValidator(errorText: 'E-mail é obrigatório'),
                  EmailValidator(errorText: 'Insira um e-mail válido')
                ]).call,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmEmailController,
                decoration: _buildInputDecoration('CONFIRME O E-MAIL', isWhiteBackground: true),
                keyboardType: TextInputType.emailAddress,
                validator: (val) => MatchValidator(errorText: 'Os e-mails não são iguais')
                    .validateMatch(val!, _emailController.text),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _cpfController,
                decoration: _buildInputDecoration('CPF', isWhiteBackground: true),
                keyboardType: TextInputType.number,
                inputFormatters: [_cpfMask],
                validator: (val) {
                  if (val == null || val.isEmpty) return 'CPF é obrigatório';
                  if (val.length != 14) return 'CPF inválido';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: _buildInputDecoration('TELEFONE', isWhiteBackground: true),
                keyboardType: TextInputType.phone,
                inputFormatters: [_phoneMask],
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Telefone é obrigatório';
                  if (val.length != 15) return 'Telefone inválido';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: _buildInputDecoration('SENHA', isWhiteBackground: true),
                validator: MultiValidator([
                  RequiredValidator(errorText: 'Senha é obrigatória'),
                  MinLengthValidator(8, errorText: 'Mínimo 8 caracteres'),
                  MaxLengthValidator(20, errorText: 'Máximo 20 caracteres'),
                ]).call,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: _buildInputDecoration('CONFIRME A SENHA', isWhiteBackground: true),
                validator: (val) => MatchValidator(errorText: 'Senhas não coincidem')
                    .validateMatch(val!, _passwordController.text),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: const Text('Sim, permito o envio de informações e eventos.', style: TextStyle(fontSize: 12)),
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
                      ? const SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
                      : const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 28),
                ),
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                child: const Text('Já possui uma conta? Faça Login'),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, {bool isWhiteBackground = false}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: isWhiteBackground ? Colors.grey.shade500 : Colors.white54),
      filled: true,
      fillColor: isWhiteBackground ? Colors.grey.shade100 : Colors.white.withOpacity(0.1),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF7F5AF0))),
      errorStyle: const TextStyle(color: Colors.red),
    );
  }
}
