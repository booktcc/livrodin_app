import 'package:flutter/material.dart';

class ButtonOption extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Function()? onPressed;
  const ButtonOption(
      {super.key, required this.iconData, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 87,
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData, size: 22),
              const SizedBox(height: 4),
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
