import 'package:livrodin/components/header.dart';
import 'package:livrodin/components/layout.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class LayoutStories extends StatelessWidget {
  const LayoutStories({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      headerProps: HeaderProps(
        showLogo: true,
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {},
        ),
        actions: [
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
      showBottomMenu: context.knobs.boolean(
        label: 'Show Bottom Menu',
        initial: true,
      ),
      child: Container(),
    );
  }
}
