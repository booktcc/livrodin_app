import 'package:app_flutter/components/bottom_menu.dart';
import 'package:app_flutter/components/header.dart';
import 'package:app_flutter/components/layout.dart';
import 'package:app_flutter/pages/home_page/genrer.dart';
import 'package:app_flutter/pages/home_page/home.dart';
import 'package:app_flutter/pages/home_page/notifications.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
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
      pageController: _pageController,
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: const [
          Home(),
          Genrer(),
          Notifications(),
        ],
      ),
    );
  }
}
