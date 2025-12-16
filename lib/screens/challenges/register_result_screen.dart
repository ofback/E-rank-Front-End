import 'package:erank_app/core/theme/app_colors.dart';
import 'package:erank_app/models/challenge.dart';
import 'package:erank_app/services/estatisticas_service.dart';
import 'package:erank_app/widgets/custom_form_field.dart';
import 'package:erank_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class RegisterResultScreen extends StatefulWidget {
  final Challenge challenge;

  const RegisterResultScreen({super.key, required this.challenge});

  @override
  State<RegisterResultScreen> createState() => _RegisterResultScreenState();
}

class _RegisterResultScreenState extends State<RegisterResultScreen> {
  final _formKey = GlobalKey<FormState>();

  final _killsController = TextEditingController();
  final _deathsController = TextEditingController();
  final _assistsController = TextEditingController();
  final _headshotsController = TextEditingController();

  bool _vitoria = false;
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await EstatisticasService.registrarResultado(
        desafioId: widget.challenge.id,
        vitoria: _vitoria,
        pontos: int.tryParse(_killsController.text) ?? 0,
        kills: int.tryParse(_killsController.text) ?? 0,
        deaths: int.tryParse(_deathsController.text) ?? 0,
        assists: int.tryParse(_assistsController.text) ?? 0,
        headshots: int.tryParse(_headshotsController.text) ?? 0,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Resultado registrado!'),
            backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Registrar Resultado'),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Partida contra ${widget.challenge.desafianteNome}",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text("Vitória?",
                    style: TextStyle(color: Colors.white)),
                subtitle: Text(_vitoria ? "Sim, eu ganhei!" : "Não, eu perdi.",
                    style:
                        TextStyle(color: _vitoria ? Colors.green : Colors.red)),
                value: _vitoria,
                activeTrackColor: Colors.green,
                activeThumbColor: Colors.white,
                onChanged: (val) => setState(() => _vitoria = val),
              ),
              const Divider(color: Colors.white24),
              const SizedBox(height: 10),
              CustomFormField(
                controller: _killsController,
                label: "Kills",
                icon: Icons.my_location,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              CustomFormField(
                controller: _deathsController,
                label: "Deaths (Mortes)",
                icon: Icons.cancel_presentation,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              CustomFormField(
                controller: _assistsController,
                label: "Assistências",
                icon: Icons.handshake,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),
              CustomFormField(
                controller: _headshotsController,
                label: "Headshots",
                icon: Icons.face,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                text: "FINALIZAR PARTIDA",
                onPressed: _submit,
                isLoading: _isLoading,
              )
            ],
          ),
        ),
      ),
    );
  }
}
