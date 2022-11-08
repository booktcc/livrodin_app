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
    this.autofillHints,
    this.obscureText = false,
    this.autofocus = false,
    TextEditingController? controller,
  }) : _controller = controller ?? TextEditingController(text: text);

  final Function(String)? onEditingComplete;
  final TextEditingController _controller;

  final Widget? leftIcon;
  final Widget? rightIcon;
  final String? hintText;
  final String? Function(String?)? validator;
  final Iterable<String>? autofillHints;
  final bool obscureText;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: autofillHints,
      obscureText: obscureText,
      onEditingComplete: () {
        if (!autofocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
