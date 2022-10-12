import 'package:app_flutter/components/bottom_menu.dart';
import 'package:app_flutter/components/button_option.dart';
import 'package:app_flutter/components/cards/book_card.dart';
import 'package:app_flutter/components/header.dart';
import 'package:app_flutter/configs/themes.dart';
import 'package:app_flutter/pages/home_page.dart';
import 'package:app_flutter/pages/login_page.dart';
import 'package:app_flutter/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const StorybookApp());
}

class StorybookApp extends StatelessWidget {
  const StorybookApp({super.key});

  @override
  Widget build(BuildContext context) => Storybook(
        wrapperBuilder: (context, child) => SafeArea(
          child: MaterialApp(
            title: 'Livrodin',
            theme: themeData,
            home: child,
            debugShowCheckedModeBanner: false,
          ),
        ),
        stories: [
          Story(
            name: 'Pages/SplashPage',
            builder: (context) => const SplashPage(),
          ),
          Story(
            name: 'Pages/HomePage',
            builder: (context) => const HomePage(),
          ),
          Story(
            name: 'Pages/LoginPage',
            builder: (context) => const LoginPage(),
          ),
          Story(
            name: 'Components/Header',
            builder: (context) => const Scaffold(
              appBar: Header(),
            ),
          ),
          Story(
            name: 'Components/BottomMenu',
            builder: (context) => const Scaffold(
              backgroundColor: dark,
              bottomNavigationBar: BottomMenu(),
            ),
          ),
          Story(
            name: 'Components/ButtonOption',
            builder: (context) => Scaffold(
              backgroundColor: lightGrey,
              body: Center(
                child: ButtonOption(
                  iconData: Icons.home,
                  text: 'Home',
                  onPressed: () {},
                ),
              ),
            ),
          ),
          Story(
            name: 'Components/BookCard',
            builder: (context) => const Scaffold(
              backgroundColor: lightGrey,
              body: Center(child: BookCard()),
            ),
          ),
        ],
      );
}
