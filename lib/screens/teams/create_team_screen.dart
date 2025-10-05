import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/widgets/custom_form_field.dart';
import 'package:erank_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:erank_app/services/team_service.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _teamNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Em lib/screens/teams/create_team_screen.dart

  Future<void> _createTeam() async {
    // Transformado em async
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final success = await TeamService.createTeam(
      name: _teamNameController.text,
      description: _descriptionController.text,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.green,
          content: Text('Time criado com sucesso!'),
        ),
      );
      // Volta para a tela anterior (tela de perfil)
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.red,
          content: Text('Erro ao criar o time. Tente novamente.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Criar Novo Time'),
        backgroundColor: AppColors.background,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Defina a identidade da sua equipe',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.white54,
                ),
              ),
              const SizedBox(height: 40),
              CustomFormField(
                controller: _teamNameController,
                label: 'Nome do Time',
                validator: RequiredValidator(
                    errorText: 'O nome do time é obrigatório'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                // Usando TextFormField padrão para um campo de múltiplas linhas
                controller: _descriptionController,
                maxLines: 4,
                style: const TextStyle(color: AppColors.black87),
                decoration: InputDecoration(
                  labelText: 'Descrição do Time',
                  labelStyle: const TextStyle(
                    color: AppColors.greyShade600,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
                validator:
                    RequiredValidator(errorText: 'A descrição é obrigatória'),
              ),
              const SizedBox(height: 40),
              PrimaryButton(
                text: 'CRIAR TIME',
                isLoading: _isLoading,
                onPressed: _createTeam,
              )
            ],
          ),
        ),
      ),
    );
  }
}
