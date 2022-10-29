import 'package:livrodin/components/bottom_menu.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  final bool showBottomMenu;
  final Widget child;
  final HeaderProps headerProps;
  const Layout(
      {super.key,
      this.showBottomMenu = false,
      required this.child,
      required this.headerProps,
      this.pageController});

  final PageController? pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        props: headerProps,
      ),
      backgroundColor: dark,
      bottomNavigationBar: showBottomMenu
          ? BottomMenu(
              pageController: pageController!,
            )
          : null,
      extendBody: true,
      body: child,
    );
  }
}
