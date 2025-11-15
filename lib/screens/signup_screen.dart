// E-rank-Front-End/lib/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:erank_app/screens/login_screen.dart';
import 'package:erank_app/services/auth_service.dart';
import 'package:erank_app/widgets/custom_form_field.dart';
import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/widgets/primary_button.dart';
import 'package:erank_app/navigation/main_navigator_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmEmailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _cpfMask = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  final _dataNascimentoMask = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  bool _isLoading = false;
  bool _agreeToTerms = false;

  Widget _buildSmallScreenHeader() {
    // ... (Método inalterado) ...
    return Column(
      children: [
        const SizedBox(height: 40),
        Image.asset('assets/erank_logo.png', height: 80),
        const SizedBox(height: 20),
        Text(
          'Criar uma Conta',
          style: GoogleFonts.exo2(
            fontSize: 32,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _dataNascimentoController.dispose();
    _nicknameController.dispose();
    _emailController.dispose();
    _confirmEmailController.dispose();
    _cpfController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.red,
          content:
              Text('Você deve aceitar os Termos de Serviço para continuar.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final user = {
      'nome': _nomeController.text,
      'nickname': _nicknameController.text,
      'email': _emailController.text,
      'senha': _passwordController.text,
      'cpf': _cpfMask.getUnmaskedText(),
      'dataNascimento': _dataNascimentoController.text,
    };

    final success = await AuthService.register(user);

    // 1. PRIMEIRA VERIFICAÇÃO (APÓS O register)
    if (!mounted) return;

    if (success) {
      final loginSuccess = await AuthService.login(
        _emailController.text,
        _passwordController.text,
      );

      // --- 2. CORREÇÃO CRÍTICA (APÓS O login) ---
      //     Adiciona a verificação de 'mounted' DEPOIS do await
      //     e ANTES de usar o 'context' (no Navigator/ScaffoldMessenger)
      if (!mounted) return;

      if (loginSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigatorScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: AppColors.green,
              content: Text('Usuário cadastrado! Faça o login.')),
        );
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } else {
      // (Esta verificação já estava protegida pela primeira)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: AppColors.red,
            content:
                Text('Erro ao cadastrar. O e-mail ou CPF já pode existir.')),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    // ... (Build method inicial inalterado) ...
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: isLargeScreen
            ? Row(
                // ... (Layout tela grande inalterado) ...
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
                                    color: AppColors.white,
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
                      child: SingleChildScrollView(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 40),
                            child: _buildSignUpFormContent(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : LayoutBuilder(
                // ... (Layout tela pequena inalterado) ...
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSmallScreenHeader(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: _buildSignUpFormContent(),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildSignUpFormContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 750 ? 2 : 1;

    // --- 3. CORREÇÃO CRÍTICA (num/double) ---
    //     Força os números a serem 'double' (4.0, 5.0)
    final childAspectRatio =
        crossAxisCount == 2 ? 4.0 : (screenWidth > 400 ? 5.0 : 4.5);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 750),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  // Este 'withOpacity' é um dos erros que você reportou.
                  // Veja a explicação na Seção 2.
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5)),
            ]),
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // ... (Header inalterado) ...
            Text('Comece sua jornada',
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: AppColors.black87,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Preencha seus dados para entrar no ranking.',
                style:
                    GoogleFonts.poppins(fontSize: 14, color: AppColors.grey)),
            const SizedBox(height: 30),

            // ... (GridView e campos inalterados) ...
            GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: childAspectRatio,
              children: [
                CustomFormField(
                  controller: _nomeController,
                  label: 'NOME COMPLETO',
                  validator:
                      RequiredValidator(errorText: 'Nome é obrigatório').call,
                ),
                CustomFormField(
                  controller: _nicknameController,
                  label: 'NICKNAME (APELIDO)',
                  validator:
                      RequiredValidator(errorText: 'Nickname é obrigatório')
                          .call,
                ),
                CustomFormField(
                  controller: _dataNascimentoController,
                  label: 'DATA DE NASCIMENTO',
                  keyboardType: TextInputType.number,
                  inputFormatters: [_dataNascimentoMask],
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Data é obrigatória';
                    }
                    if (val.length != 10) return 'Data inválida';
                    return null;
                  },
                ),
                CustomFormField(
                  controller: _cpfController,
                  label: 'CPF',
                  keyboardType: TextInputType.number,
                  inputFormatters: [_cpfMask],
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'CPF é obrigatório';
                    }
                    if (val.length != 14) return 'CPF inválido';
                    return null;
                  },
                ),
                CustomFormField(
                  controller: _emailController,
                  label: 'E-MAIL',
                  keyboardType: TextInputType.emailAddress,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'E-mail é obrigatório'),
                    EmailValidator(errorText: 'Insira um e-mail válido')
                  ]).call,
                ),
                CustomFormField(
                  controller: _confirmEmailController,
                  label: 'CONFIRME O E-MAIL',
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) =>
                      MatchValidator(errorText: 'Os e-mails não são iguais')
                          .validateMatch(val!, _emailController.text),
                ),
                CustomFormField(
                  controller: _passwordController,
                  label: 'SENHA',
                  obscureText: true,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Senha é obrigatória'),
                    MinLengthValidator(8, errorText: 'Mínimo 8 caracteres'),
                  ]).call,
                ),
                CustomFormField(
                  controller: _confirmPasswordController,
                  label: 'CONFIRME A SENHA',
                  obscureText: true,
                  validator: (val) =>
                      MatchValidator(errorText: 'Senhas não coincidem')
                          .validateMatch(val!, _passwordController.text),
                ),
              ],
            ),

            const SizedBox(height: 20),

            CheckboxListTile(
              title: Text("Eu li e aceito os Termos de Serviço",
                  style: GoogleFonts.poppins(fontSize: 14)),
              value: _agreeToTerms,
              onChanged: (newValue) {
                setState(() {
                  _agreeToTerms = newValue ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),

            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : PrimaryButton(
                    text: 'CADASTRAR',
                    onPressed: _registerUser,
                  ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen())),
              child: const Text('Já possui uma conta? Faça Login'),
            ),
          ]),
        ),
      ),
    );
  }
}
