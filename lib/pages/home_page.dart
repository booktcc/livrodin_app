import 'package:flutter/material.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/pages/home_page/genrer.dart';
import 'package:livrodin/pages/home_page/home.dart';
import 'package:livrodin/pages/home_page/notifications_view.dart';

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
          const Home(),
          Genrer(),
          const NotificationsView(),
        ],
      ),
    );
  }
}
