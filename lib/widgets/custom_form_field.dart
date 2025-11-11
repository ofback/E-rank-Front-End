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
  // CORREÇÃO 1: A variável de estado é movida para aqui (fora do 'build').
  // Assim, o seu valor é preservado quando o 'setState' é chamado.
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    // CORREÇÃO 2: A variável 'isDarkMode' foi removida pois não estava
    // a ser usada em lado nenhum.
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: widget.controller,
      // A lógica do obscureText agora usa a variável de estado 'isObscured'
      obscureText: widget.obscureText ? isObscured : false,
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
                  // AGORA FUNCIONA: O estado de 'isObscured' é preservado
                  // e o ícone pode alternar entre os dois estados.
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
