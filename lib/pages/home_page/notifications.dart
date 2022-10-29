import 'package:livrodin/components/title.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

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
          children: [
            PageTitle(
              title: "Notificações",
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings_rounded),
                ),
                IconButton(
                  iconSize: 28,
                  onPressed: () {},
                  icon: const Icon(Icons.clear_all_rounded),
                ),
              ],
            ),
            const Expanded(
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
