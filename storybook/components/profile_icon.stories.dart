import 'package:app_flutter/components/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

import '../utils/fake_data.dart';

class ProfileIconStories extends StatelessWidget {
  const ProfileIconStories({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ProfileIcon(
            image: context.knobs.text(
              label: "Image url",
              initial: fakeImageProfile,
            ),
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
