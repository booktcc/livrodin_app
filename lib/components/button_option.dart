import 'package:flutter/material.dart';

class ButtonOption extends StatelessWidget {
  final Color? color;
  final IconData iconData;
  final String text;
  final Function()? onPressed;
  const ButtonOption({
    super.key,
    required this.iconData,
    required this.text,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    var isDisabled = onPressed == null;
    return SizedBox(
      width: 87,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1,
        child: InkWell(
          onTap: onPressed,
          child: Ink(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(iconData, size: 22, color: color),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    color: color,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
