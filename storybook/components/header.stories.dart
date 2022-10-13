import 'package:app_flutter/components/header.dart';
import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

class HeaderStories extends StatefulWidget {
  const HeaderStories({super.key});

  @override
  State<HeaderStories> createState() => _HeaderStoriesState();
}

enum _HeaderStoriesType {
  homepage,
  profile,
  offer,
  bookDetails;

  Header header() {
    switch (this) {
      case _HeaderStoriesType.homepage:
        return Header(
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
        );
      case _HeaderStoriesType.profile:
        return Header(
          title: 'Perfil',
          showBackButton: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.manage_accounts),
              onPressed: () {},
            ),
          ],
        );
      case _HeaderStoriesType.offer:
        return const Header(
          title: 'Doações',
          showBackButton: true,
        );
      case _HeaderStoriesType.bookDetails:
        return Header(
          showLogo: true,
          showBackButton: true,
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
        );
    }
  }
}

class _HeaderStoriesState extends State<HeaderStories> {
  final _HeaderStoriesType current = _HeaderStoriesType.homepage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: context.knobs.options(
      label: "Variantes",
      initial: _HeaderStoriesType.homepage.header(),
      options: _HeaderStoriesType.values
          .map((e) => Option(
                label: e.name.toString(),
                value: e.header(),
              ))
          .toList(),
    ));
  }
}
