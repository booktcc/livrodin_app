import 'package:flutter/material.dart';
import 'package:livrodin/models/book.dart';

class TabViewSynopsis extends StatelessWidget {
  const TabViewSynopsis({
    super.key,
    required this.book,
    required this.scrollController,
  });

  final ScrollController scrollController;
  final Book book;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverToBoxAdapter(
            child: Text(
              book.synopsis ?? "",
              textAlign: TextAlign.justify,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
