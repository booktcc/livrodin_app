import 'package:flutter/material.dart';

class ButtonOptionProfile extends StatelessWidget {
  const ButtonOptionProfile({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.radius = 0,
  });

  final String label;
  final IconData icon;
  final Function()? onPressed;

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        onTap: onPressed,
        child: Ink(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
