import 'package:app_flutter/components/header.dart';
import 'package:app_flutter/components/layout.dart';
import 'package:app_flutter/pages/home_page/genrer.dart';
import 'package:app_flutter/pages/home_page/home.dart';
import 'package:app_flutter/pages/home_page/notifications.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, int initialIndex = 0})
      : _pageController = PageController(initialPage: initialIndex),
        super(key: key);

  final PageController _pageController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      headerProps: HeaderProps(
        showLogo: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      showBottomMenu: true,
      pageController: widget._pageController,
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: widget._pageController,
        children: [
          Home(),
          const Genrer(),
          const Notifications(),
        ],
      ),
    );
  }
}
