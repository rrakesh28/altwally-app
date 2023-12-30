import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final IconData prefixIcon;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    required this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.black38,
          ),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.black38,
            )),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        prefixIcon: Icon(prefixIcon),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Enter your $hintText';
        }
        return null;
      },
      maxLines: maxLines,
    );
  }
}
