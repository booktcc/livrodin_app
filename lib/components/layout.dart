import 'package:flutter/material.dart';
import 'package:livrodin/components/bottom_menu.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/configs/themes.dart';

class Layout extends StatelessWidget {
  final bool showBottomMenu;
  final Widget child;
  final HeaderProps? headerProps;
  final bool? resizeToAvoidBottomInset;
  const Layout(
      {super.key,
      this.showBottomMenu = false,
      required this.child,
      this.headerProps,
      this.pageController,
      this.resizeToAvoidBottomInset = false});

  final PageController? pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerProps != null
          ? Header(
              props: headerProps!,
            )
          : null,
      backgroundColor: dark,
      bottomNavigationBar: showBottomMenu
          ? BottomMenu(
              pageController: pageController!,
            )
          : null,
      extendBody: true,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: child,
    );
  }
}
