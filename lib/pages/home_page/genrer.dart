import 'package:livrodin/components/title.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:flutter/material.dart';

class Genrer extends StatelessWidget {
  const Genrer({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(pageRadius),
      ),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: lightGrey,
        ),
        child: Column(
          children: const [
            PageTitle(
              title: "Gêneros",
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
