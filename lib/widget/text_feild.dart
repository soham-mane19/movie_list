import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFeild extends StatelessWidget {
  CustomTextFeild({
    super.key,
    required this.hintText,
    required this.controller,
    required this.validator,
  });

  final String hintText;
  final TextEditingController controller;
  final String? Function(String? value) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator, // This will check the validation
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: const Color.fromRGBO(27, 30, 40, 1),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(14),
        ),
        fillColor: const Color.fromRGBO(247, 247, 249, 1),
        filled: true,
      ),
    );
  }
}
