import 'package:app_flutter/components/bottom_menu.dart';
import 'package:app_flutter/components/header.dart';
import 'package:app_flutter/configs/themes.dart';
import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final bool showBottomMenu;
  final Widget child;
  const Layout({super.key, this.showBottomMenu = false, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      backgroundColor: dark,
      bottomNavigationBar: showBottomMenu ? const BottomMenu() : null,
      extendBody: true,
      body: child,
    );
  }
}
