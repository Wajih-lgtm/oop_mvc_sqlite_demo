import 'package:flutter/material.dart';

/// حقل نصي معاد الاستخدام ليوحّد النمط عبر الشاشات.
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.obscure = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: obscure ? const Icon(Icons.lock) : const Icon(Icons.text_fields),
      ),
    );
  }
}
