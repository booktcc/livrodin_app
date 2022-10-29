import 'package:livrodin/configs/themes.dart';
import 'package:flutter/material.dart';

class FilterOption extends StatefulWidget {
  final String title;
  final bool selected;
  final void Function()? onTap;
  const FilterOption(
      {super.key, required this.title, this.selected = false, this.onTap});

  @override
  State<FilterOption> createState() => _FilterOptionState();
}

const bgColor = Color(0xFFECECEC);
const borderRadius = 20.0;
const activeColor = dark;
const inactiveColor = Color(0xFF646E77);

class _FilterOptionState extends State<FilterOption> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(borderRadius),
      child: Ink(
        width: 96,
        height: 32,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.selected ? Icons.check_circle : Icons.cancel,
              color: widget.selected ? activeColor : inactiveColor,
              size: 18,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              widget.title,
              style: TextStyle(
                color: widget.selected ? activeColor : inactiveColor,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
