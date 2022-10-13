import 'package:flutter/material.dart';

class ButtonOptionProfile extends StatelessWidget {
  const ButtonOptionProfile(
      {super.key,
      required this.label,
      required this.icon,
      this.onPressed,
      this.topLeftRadius = 0,
      this.topRightRadius = 0,
      this.bottomLeftRadius = 0,
      this.bottomRightRadius = 0});

  final String label;
  final IconData icon;
  final Function()? onPressed;

  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: InkWell(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeftRadius),
          topRight: Radius.circular(topRightRadius),
          bottomLeft: Radius.circular(bottomLeftRadius),
          bottomRight: Radius.circular(bottomRightRadius),
        ),
        onTap: () {},
        child: Ink(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 30),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(label),
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
