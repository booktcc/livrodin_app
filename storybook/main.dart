import 'package:app_flutter/pages/home_page.dart';
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
        stories: [
          Story(
            name: 'Pages/SplashPage',
            builder: (context) => const SplashPage(),
          ),
          Story(
            name: 'Pages/HomePage',
            builder: (context) => const HomePage(),
          ),
        ],
      );
}
