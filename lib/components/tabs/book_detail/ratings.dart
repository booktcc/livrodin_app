import 'package:flutter/material.dart';

class TabViewRatings extends StatelessWidget {
  const TabViewRatings({super.key, required ScrollController scrollController})
      : _scrollController = scrollController;

  final ScrollController _scrollController;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [],
    );
  }
}
