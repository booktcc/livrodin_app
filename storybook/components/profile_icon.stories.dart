import 'package:app_flutter/components/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class ProfileIconStories extends StatelessWidget {
  const ProfileIconStories({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ProfileIcon(
            image: context.knobs.text(
                label: "Image url",
                initial:
                    "https://avatars.githubusercontent.com/u/47704204?v=4"),
            size: context.knobs.options(
              label: "Size",
              initial: ProfileSize.xl,
              options: ProfileSize.values
                  .map((e) => Option(label: e.toString(), value: e))
                  .toList(),
            ),
          ),
        ),
      );
}
