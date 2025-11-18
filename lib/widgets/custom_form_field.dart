import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:erank_app/core/theme/app_colors.dart';

class CustomFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String label;
  final IconData
      icon; // Adicionado para manter compatibilidade com seu design anterior
  final String? Function(String?)? validator;
  final bool
      isPassword; // Renomeado de obscureText para clareza (padrão anterior)
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;

  const CustomFormField({
    super.key,
    required this.label,
    required this.icon,
    this.controller,
    this.validator,
    this.isPassword = false,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  // Controla a visibilidade da senha internamente
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rótulo acima do campo
        Text(
          widget.label,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            // Fundo escuro translúcido para destacar o campo do background da tela
            // ignore: deprecated_member_use
            color: AppColors.black87.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            maxLines: widget.isPassword ? 1 : widget.maxLines,

            // Lógica: Se não for campo de senha, nunca obscurece.
            // Se for senha, obedece a variável de estado _isObscured.
            obscureText: widget.isPassword ? _isObscured : false,

            // --- ESTILO DO TEXTO DIGITADO (Correção de Visibilidade) ---
            style: const TextStyle(
              color: Colors.white, // Texto BRANCO para contraste máximo
              fontWeight: FontWeight.w600, // Semi-negrito para legibilidade
              fontSize: 16,
              letterSpacing: 0.5,
            ),
            cursorColor: AppColors.primary,

            decoration: InputDecoration(
              prefixIcon: Icon(widget.icon, color: AppColors.white54),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

              // Ícone de Olho (Apenas se for senha)
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _isObscured ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.white54,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    )
                  : null,

              errorStyle: const TextStyle(
                color: AppColors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
