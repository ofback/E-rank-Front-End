import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:erank_app/core/theme/app_colors.dart';

class CustomFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CustomFormField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  @override
  Widget build(BuildContext context) {
    bool isObscured = true;
    // Detecta se o fundo é escuro para adaptar o estilo.
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: widget.controller, // Use widget. para acessar as propriedades
      obscureText:
          widget.obscureText ? isObscured : false, // Use a variável de estado
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(
          color: AppColors.greyShade600, // Usar uma cor consistente
        ),
        filled: true,
        fillColor: Colors.grey.shade100, // Um cinza claro padrão
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        errorStyle: const TextStyle(color: AppColors.red),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  isObscured ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.grey,
                ),
                onPressed: () {
                  setState(() {
                    isObscured = !isObscured;
                  });
                },
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}
