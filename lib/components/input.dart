import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  Input({
    super.key,
    String? text,
    this.onEditingComplete,
    this.leftIcon,
    this.rightIcon,
    this.hintText,
    this.validator,
  }) : _controller = TextEditingController(text: text);

  final Function(String)? onEditingComplete;
  final TextEditingController _controller;

  final Widget? leftIcon;
  final Widget? rightIcon;
  final String? hintText;
  final String Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onEditingComplete?.call(_controller.text);
      },
      controller: _controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: hintText,
        hintMaxLines: 1,
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.black),
        ),
        prefixIcon: leftIcon,
        suffixIcon: rightIcon,
      ),
      validator: validator,
    );
  }
}
