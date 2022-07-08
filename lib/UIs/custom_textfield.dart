import 'package:flutter/material.dart';
import 'package:trade/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key, this.labelText, required this.controller, this.maxLength, this.maxLines=1})
      : super(key: key);

  final String? labelText;
  final TextEditingController controller;
  final int? maxLength;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 25),
      child: TextField(
        maxLines: maxLines,
        maxLength: maxLength,
        controller: controller,
        style: Theme.of(context).textTheme.headline6,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: color2),
          ),
          labelText: labelText,
          labelStyle: const TextStyle(color: colorText),
        ),
      ),
    );
  }
}
