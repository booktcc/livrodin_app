import 'package:app_flutter/configs/themes.dart';
import 'package:flutter/material.dart';

class Genrer extends StatelessWidget {
  const Genrer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: lightGrey,
      ),
    );
  }
}
