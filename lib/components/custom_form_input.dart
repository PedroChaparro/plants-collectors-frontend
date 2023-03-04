import 'package:flutter/material.dart';

class CustomFormInput extends StatelessWidget {
  final String label;
  final bool obscureText;
  final String? Function(String?) validator;

  const CustomFormInput(
      {super.key,
      required this.label,
      required this.obscureText,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    // Wrap the TextField in a Container to add a margin
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      // Text field itself
      child: TextFormField(
        // Text field options
        obscureText: obscureText,
        // Text field styles
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFACACAC), width: 1.2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFACACAC), width: 1.2),
          ),
          // Text field options
          // Text field label
          labelStyle: const TextStyle(color: Color(0xFFACACAC)),
          labelText: label,
        ),
        validator: validator,
      ),
    );
  }
}
