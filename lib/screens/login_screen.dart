import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:erank_app/screens/signup_screen.dart';

// TODO: Importar a tela principal do app após o login
// import 'package:erank_app/screens/home_screen.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Endpoint de login da sua API
    final url = Uri.parse('http://localhost:8080/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
          'senha': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Login realizado com sucesso!')),
        );
        // TODO: Salvar o token e navegar para a tela principal
        // final responseData = json.decode(response.body);
        // final token = responseData['token'];
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.red,
              content: Text('E-mail ou senha inválidos.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Não foi possível conectar ao servidor.')),
      );
      print(e); // Para depuração
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth > 800;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E), // Cor de fundo substituída
      body: SafeArea(
        child: isLargeScreen
            ? Row(
                children: [
                  Expanded(
                    // Lado esquerdo: Formulário
                    flex: 1,
                    child: Container(
                      color: const Color(0xFF1A1A2E),
                      child: Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 40.0),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 750),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildLoginForm(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    // Lado direito: Imagem e texto
                    flex: 1,
                    child: Stack(
                      // Usamos o Stack para posicionar a imagem e o conteúdo separadamente
                      children: [
                        // Imagem do personagem, posicionada à esquerda
                        Positioned(
                          left:
                              -100, // Ajuste este valor para mover a imagem para a esquerda
                          top: 0,
                          bottom: 0,
                          child: Image.asset(
                            'assets/background_signup3.png', // Imagem do personagem
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Conteúdo (Logo e texto "ENTRAR NA CONTA"), alinhado à direita
                        Positioned.fill(
                          // Preenche todo o espaço disponível
                          child: Padding(
                            padding: const EdgeInsets.all(48.0),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.end, // Alinha à direita
                              children: [
                                Image.asset(
                                  'assets/erank_logo.png',
                                  height: 200,
                                ),
                                const Spacer(),
                                Text(
                                  'ENTRAR NA\nCONTA',
                                  textAlign: TextAlign
                                      .right, // Garante alinhamento do texto
                                  style: GoogleFonts.exo2(
                                    fontSize: 64,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    height: 1.0,
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Center(child: _buildLoginForm()),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Bem-vindo de volta!',
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                  fontSize: 24,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Preencha seus dados para continuar.',
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                  fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _emailController,
              decoration:
                  _buildInputDecoration('E-MAIL', isWhiteBackground: true),
              style: const TextStyle(color: Colors.black87),
              keyboardType: TextInputType.emailAddress,
              validator: MultiValidator([
                RequiredValidator(errorText: 'E-mail é obrigatório'),
                EmailValidator(errorText: 'Insira um e-mail válido')
              ]).call,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration:
                  _buildInputDecoration('SENHA', isWhiteBackground: true),
              style: const TextStyle(color: Colors.black87),
              validator:
                  RequiredValidator(errorText: 'Senha é obrigatória').call,
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 60,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _loginUser,
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
                          strokeWidth: 3,
                          color: Colors.white,
                        ))
                    : const Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 28),
              ),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SignUpScreen())); // Removido 'const' aqui
              },
              child: Text(
                'Não possui uma conta? Cadastre-se',
                style: GoogleFonts.poppins(
                    color: const Color(0xFF7F5AF0),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label,
      {bool isWhiteBackground = false}) {
    return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: isWhiteBackground ? Colors.grey.shade500 : Colors.white54,
            fontWeight: FontWeight.bold),
        filled: true,
        fillColor: isWhiteBackground
            ? Colors.grey.shade100
            : Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF7F5AF0)),
        ),
        errorStyle: TextStyle(color: Colors.red.shade600));
  }
}
