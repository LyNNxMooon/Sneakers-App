import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';

class SearchBoxWidget extends StatelessWidget {
  const SearchBoxWidget({
    super.key,
    required this.hintText,
    required this.label,
    required this.controller,
    this.function,
    this.keyboardType
  });

  final String hintText;
  final String label;
  final TextEditingController controller;
  final void Function(String)? function;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      onChanged: (value) {
        if (function != null) {
          function!(value);
        }
      },
      controller: controller,
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 12),
        labelText: label,
        labelStyle: const TextStyle(color: kThirdColor, fontSize: 12),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 2, color: kThirdColor),
          borderRadius: BorderRadius.circular(18),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: kFourthColor),
          borderRadius: BorderRadius.circular(18),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: kFourthColor),
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }
}
