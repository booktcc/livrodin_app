import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/controllers/book_detail_controller.dart';

class TabViewDetails extends StatelessWidget {
  TabViewDetails({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;
  final BookDetailController _bookDetailController =
      Get.find<BookDetailController>();
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(10),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                _detail(
                  "Data de Lançamento",
                  _bookDetailController.book!.publishedDate != null
                      ? "${_bookDetailController.book!.publishedDate!.day}/${_bookDetailController.book!.publishedDate!.month}/${_bookDetailController.book!.publishedDate!.year}"
                      : "Sem Data",
                ),
                const SizedBox(height: 10),
                _detail(
                  "Páginas",
                  _bookDetailController.book!.pageCount?.toString() ?? "",
                ),
                const SizedBox(height: 10),
                _detail(
                  "Idioma",
                  _bookDetailController.book!.language?.toString() ?? "",
                ),
                const SizedBox(height: 10),
                _detail(
                  "Gêneros",
                  _bookDetailController.book!.genresString,
                ),
                const SizedBox(height: 10),
                _detail(
                  "Editora",
                  _bookDetailController.book!.publisher?.toString() ??
                      "Sem Informação",
                ),
                const SizedBox(height: 10),
                _detail(
                  "ISBN-10",
                  _bookDetailController.book!.isbn10 ?? "",
                ),
                const SizedBox(height: 10),
                _detail(
                  "ISBN-13",
                  _bookDetailController.book!.isbn13 ?? "",
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _detail(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            softWrap: true,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
