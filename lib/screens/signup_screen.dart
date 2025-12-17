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

  Color? _nomeColor;
  Color? _nickColor;
  Color? _dataColor;
  Color? _cpfColor;
  Color? _emailColor;
  Color? _confirmEmailColor;
  Color? _passColor;
  Color? _confirmPassColor;

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

  void _validateNome(String val) {
    setState(() {
      if (val.isEmpty) {
        _nomeColor = null;
      } else if (val.trim().split(' ').length >= 2) {
        _nomeColor = Colors.greenAccent;
      } else {
        _nomeColor = Colors.redAccent;
      }
    });
  }

  void _validateNick(String val) {
    setState(() {
      if (val.isEmpty) {
        _nickColor = null;
      } else if (val.length >= 2) {
        _nickColor = Colors.greenAccent;
      } else {
        _nickColor = Colors.redAccent;
      }
    });
  }

  void _validateDate(String val) {
    setState(() {
      if (val.isEmpty) {
        _dataColor = null;
        return;
      }

      if (val.length != 10) {
        _dataColor = Colors.redAccent;
        return;
      }

      try {
        final parts = val.split('/');
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);

        if (day > 0 && day <= 31 && month > 0 && month <= 12 && year > 1900) {
          _dataColor = Colors.greenAccent;
        } else {
          _dataColor = Colors.redAccent;
        }
      } catch (e) {
        _dataColor = Colors.redAccent;
      }
    });
  }

  void _validateCPF(String val) {
    setState(() {
      if (val.isEmpty) {
        _cpfColor = null;
      } else if (val.length == 14) {
        _cpfColor = Colors.greenAccent;
      } else {
        _cpfColor = Colors.redAccent;
      }
    });
  }

  void _validateEmail(String val) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      if (val.isEmpty) {
        _emailColor = null;
      } else if (emailRegex.hasMatch(val)) {
        _emailColor = Colors.greenAccent;
      } else {
        _emailColor = Colors.redAccent;
      }
    });
  }

  void _validateConfirmEmail(String val) {
    setState(() {
      if (val.isEmpty) {
        _confirmEmailColor = null;
      } else if (val == _emailController.text &&
          _emailColor == Colors.greenAccent) {
        _confirmEmailColor = Colors.greenAccent;
      } else {
        _confirmEmailColor = Colors.redAccent;
      }
    });
  }

  void _validatePass(String val) {
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}$');

    setState(() {
      if (val.isEmpty) {
        _passColor = null;
      } else if (passwordRegex.hasMatch(val)) {
        _passColor = Colors.greenAccent;
      } else {
        _passColor = Colors.redAccent;
      }
    });
  }

  void _validateConfirmPass(String val) {
    setState(() {
      if (val.isEmpty) {
        _confirmPassColor = null;
      } else if (val == _passwordController.text) {
        _confirmPassColor = Colors.greenAccent;
      } else {
        _confirmPassColor = Colors.redAccent;
      }
    });
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

    if (!mounted) return;

    if (success) {
      final loginSuccess = await AuthService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      if (loginSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigatorScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Usuário cadastrado! Faça o login.')),
        );
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: AppColors.red,
            content:
                Text('Erro ao cadastrar. O e-mail ou CPF já pode existir.')),
      );
    }

    setState(() => _isLoading = false);
  }

  // Header Mobile
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
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0C29),
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
                  // Direita
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
            // Mobile
            : LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/background_signup2.png',
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) =>
                              Container(color: const Color(0xFF0F0C29)),
                        ),
                      ),
                      SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildSmallScreenHeader(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0),
                                  child: _buildSignUpFormContent(),
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Widget _buildSignUpFormContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 750 ? 2 : 1;
    final double childAspectRatio =
        crossAxisCount == 2 ? 4.0 : (screenWidth > 400 ? 5.0 : 4.5);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 750),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5)),
            ]),
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text('Comece sua jornada',
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Preencha seus dados para entrar no ranking.',
                style:
                    GoogleFonts.poppins(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 30),
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
                  icon: Icons.person,
                  borderColor: _nomeColor,
                  onChanged: _validateNome,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Nome é obrigatório';
                    }
                    if (val.trim().split(' ').length < 2) {
                      return 'Digite nome e sobrenome';
                    }
                    return null;
                  },
                ),
                CustomFormField(
                  controller: _nicknameController,
                  label: 'NICKNAME',
                  icon: Icons.alternate_email,
                  borderColor: _nickColor,
                  onChanged: _validateNick,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Obrigatório';
                    if (val.length < 2) return 'Mínimo 2 caracteres';
                    return null;
                  },
                ),
                CustomFormField(
                  controller: _dataNascimentoController,
                  label: 'NASCIMENTO',
                  icon: Icons.calendar_today,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_dataNascimentoMask],
                  borderColor: _dataColor,
                  onChanged: _validateDate,
                  validator: (val) {
                    if (val == null || val.length != 10) return 'Data inválida';

                    try {
                      final parts = val.split('/');
                      final d = int.parse(parts[0]);
                      final m = int.parse(parts[1]);
                      if (d > 31 || m > 12 || d < 1 || m < 1) {
                        return 'Data inválida';
                      }
                    } catch (e) {
                      return 'Data inválida';
                    }
                    return null;
                  },
                ),
                CustomFormField(
                  controller: _cpfController,
                  label: 'CPF',
                  icon: Icons.badge,
                  keyboardType: TextInputType.number,
                  inputFormatters: [_cpfMask],
                  borderColor: _cpfColor,
                  onChanged: _validateCPF,
                  validator: (val) =>
                      (val == null || val.length != 14) ? 'CPF Inválido' : null,
                ),
                CustomFormField(
                  controller: _emailController,
                  label: 'E-MAIL',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  borderColor: _emailColor,
                  onChanged: _validateEmail,
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Obrigatório'),
                    EmailValidator(errorText: 'Inválido')
                  ]).call,
                ),
                CustomFormField(
                  controller: _confirmEmailController,
                  label: 'CONFIRME O E-MAIL',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  borderColor: _confirmEmailColor,
                  onChanged: _validateConfirmEmail,
                  validator: (val) =>
                      MatchValidator(errorText: 'E-mails não coincidem')
                          .validateMatch(val!, _emailController.text),
                ),
                CustomFormField(
                  controller: _passwordController,
                  label: 'SENHA',
                  icon: Icons.lock,
                  isPassword: true,
                  borderColor: _passColor,
                  onChanged: _validatePass,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Obrigatória';
                    final passwordRegex =
                        RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}$');
                    if (!passwordRegex.hasMatch(val)) {
                      return 'Mín 8 chars, 1 num, 1 maiús, 1 minús';
                    }
                    return null;
                  },
                ),
                CustomFormField(
                  controller: _confirmPasswordController,
                  label: 'CONFIRME A SENHA',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  borderColor: _confirmPassColor,
                  onChanged: _validateConfirmPass,
                  validator: (val) =>
                      MatchValidator(errorText: 'Senhas não coincidem')
                          .validateMatch(val!, _passwordController.text),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white70),
              child: CheckboxListTile(
                title: Text("Eu li e aceito os Termos de Serviço",
                    style:
                        GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                value: _agreeToTerms,
                onChanged: (newValue) =>
                    setState(() => _agreeToTerms = newValue ?? false),
                activeColor: AppColors.primary,
                checkColor: Colors.white,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
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
              child: const Text('Já possui uma conta? Faça Login',
                  style: TextStyle(color: Colors.white70)),
            ),
          ]),
        ),
      ),
    );
  }
}
