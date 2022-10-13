import 'package:app_flutter/components/profile_info.dart';
import 'package:app_flutter/configs/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
