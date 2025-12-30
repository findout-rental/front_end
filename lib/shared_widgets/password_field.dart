// lib/shared_widgets/password_field.dart

import 'package:flutter/material.dart';
import 'package:project/shared_widgets/custom_text_field.dart';

class PasswordField extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;

  const PasswordField({super.key, required this.hint, this.controller});




  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: widget.controller,
      hint: widget.hint,
      icon: Icons.lock_outline,

      obscureText: _obscureText,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}
