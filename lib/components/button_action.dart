import 'package:flutter/material.dart';
import 'package:livrodin/configs/themes.dart';

class ButtonAction extends StatelessWidget {
  const ButtonAction({
    super.key,
    required this.onPressed,
    this.minHeight = 0,
    this.minWidth = 0,
    this.icon,
    this.iconSize = 20,
    this.label,
    this.fontSize = 14,
    this.radius = 90,
    this.color = red,
    this.textColor = Colors.white,
    this.rounded = false,
  });

  final double minWidth;
  final double minHeight;
  final VoidCallback onPressed;
  final IconData? icon;
  final double iconSize;
  final String? label;
  final double fontSize;
  final double radius;
  final Color color;
  final Color textColor;
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    var hasOnlyElement =
        !(label != null && icon == null || label == null && icon != null);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(radius),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: minWidth,
            minHeight: minHeight,
          ),
          child: Ink(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  spreadRadius: 0.1,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: label != null
                ? const EdgeInsets.symmetric(horizontal: 15, vertical: 10)
                : const EdgeInsets.all(0),
            child: Row(
              mainAxisAlignment: hasOnlyElement
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: icon != null,
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: textColor,
                  ),
                ),
                Visibility(
                  visible: hasOnlyElement,
                  child: const SizedBox(width: 10),
                ),
                Visibility(
                  visible: label != null,
                  child: Text(
                    label ?? "",
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontFamily: "Avenir",
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
