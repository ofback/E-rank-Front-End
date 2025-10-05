import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:erank_app/screens/login_screen.dart';
import 'package:erank_app/services/auth_service.dart';
import 'package:erank_app/widgets/custom_form_field.dart';
import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/widgets/primary_button.dart';

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
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _cpfMask = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

  bool _isLoading = false;
  bool _agreeToTerms = false;
  bool _acceptMarketing = false;

  Widget _buildSmallScreenHeader() {
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
      'nome': _nicknameController.text,
      'nickname': _nicknameController.text,
      'email': _emailController.text,
      'senha': _passwordController.text,
      'cpf': _cpfMask.getUnmaskedText(),
      'dataNascimento': "01/01/2000",
    };

    final success = await AuthService.register(user);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: AppColors.green,
            content: Text('Usuário cadastrado com sucesso! Faça o login.')),
      );
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: AppColors.red,
            content: Text('Erro ao cadastrar. O e-mail já pode existir.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;

    return Scaffold(
      backgroundColor: AppColors.background,
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
                        child: Column(
                          children: [
                            _buildSmallScreenHeader(),
                            _buildSignUpForm(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Center(child: _buildSignUpForm()),
      ),
    );
  }

  Widget _buildSignUpForm() {
    // Determina o número de colunas com base na largura da tela
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount =
        screenWidth > 750 ? 2 : 1; // 2 colunas se a tela for larga

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 750),
        child: Container(
          decoration: BoxDecoration(
              color: AppColors.white,
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
                          color: AppColors.black87,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Preencha seus dados para entrar no ranking.',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: AppColors.grey)),
                  const SizedBox(height: 30),

                  // --- NOVO LAYOUT COM GRIDVIEW ---
                  GridView.count(
                    crossAxisCount: crossAxisCount,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio:
                        4, // Ajuste este valor para mudar a altura dos campos
                    children: [
                      CustomFormField(
                        controller: _nicknameController,
                        label: 'NICKNAME',
                        validator: RequiredValidator(
                                errorText: 'Nickname é obrigatório')
                            .call,
                      ),
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
                        validator: (val) => MatchValidator(
                                errorText: 'Os e-mails não são iguais')
                            .validateMatch(val!, _emailController.text),
                      ),
                      CustomFormField(
                        controller: _passwordController,
                        label: 'SENHA',
                        obscureText: true,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'Senha é obrigatória'),
                          MinLengthValidator(8,
                              errorText: 'Mínimo 8 caracteres'),
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
                  // --- FIM DO NOVO LAYOUT ---

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
