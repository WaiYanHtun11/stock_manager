import 'package:flutter/material.dart';

// ignore: must_be_immutable
class InputField extends StatelessWidget {
  InputField(
      {required this.label,
      required this.controller,
      this.maxLines,
      this.type,
      this.suffixIcon,
      super.key});
  final String label;
  final String? initValue = '';
  final TextEditingController controller;
  TextInputType? type = TextInputType.text;
  int? maxLines = 1;
  final IconButton? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLines,
        validator: (String? data) {
          if (data == null || data.isEmpty) {
            return 'Please Fill This Form';
          }
          return null;
        },
        enableInteractiveSelection: false,
        decoration: InputDecoration(
            labelText: label,
            alignLabelWithHint: true,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            contentPadding: const EdgeInsets.all(16.0),
            suffixIcon: suffixIcon),
      ),
    );
  }
}
