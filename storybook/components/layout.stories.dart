import 'package:app_flutter/components/layout.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class LayoutStories extends StatelessWidget {
  const LayoutStories({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      showBottomMenu: context.knobs.boolean(
        label: 'Show Bottom Menu',
        initial: true,
      ),
      child: Container(),
    );
  }
}
