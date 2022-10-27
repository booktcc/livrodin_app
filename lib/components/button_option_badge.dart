import 'package:app_flutter/configs/themes.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class ButtonOptionBadge extends StatelessWidget {
  final IconData iconData;
  final String text;
  final int badgeCount;
  final Function()? onPressed;

  const ButtonOptionBadge({
    super.key,
    required this.iconData,
    required this.text,
    this.badgeCount = 0,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          width: 90,
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: Badge(
                  showBadge: badgeCount > 0,
                  badgeColor: red,
                  badgeContent: Text(
                    badgeCount < 10 ? "0$badgeCount" : "$badgeCount",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  child: Icon(iconData, size: 35),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: grey,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
