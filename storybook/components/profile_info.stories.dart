import 'package:livrodin/components/profile_info.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:flutter/material.dart';

import '../utils/fake_data.dart';

class ProfileInfoStories extends StatelessWidget {
  const ProfileInfoStories({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: lightGrey,
      body: Center(
        child: ProfileInfo(
          name: fakeName,
          email: fakeEmail,
          image: fakeImageProfile,
        ),
      ),
    );
  }
}
