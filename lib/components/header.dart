import 'package:app_flutter/configs/themes.dart';
import 'package:flutter/material.dart';

class Header extends StatefulWidget with PreferredSizeWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 52,
      centerTitle: true,
      title: const Text(
        "LIVRODIN",
        style: TextStyle(
          fontSize: 18,
          letterSpacing: 18 * 0.29,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: dark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
      leading: IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {},
      ),
      elevation: 0,
    );
  }
}
