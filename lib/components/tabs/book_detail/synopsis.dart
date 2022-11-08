import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/controllers/book_detail_controller.dart';

class TabViewSynopsis extends StatelessWidget {
  TabViewSynopsis({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;
  final BookDetailController _bookDetailController =
      Get.find<BookDetailController>();
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverToBoxAdapter(
            child: Text(
              _bookDetailController.book!.synopsis ?? "",
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
