import 'package:flutter/material.dart';
import 'package:livrodin/models/book.dart';

class TabViewDetails extends StatelessWidget {
  const TabViewDetails({
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
            child: Column(
              children: [
                _detail(
                  "Data de Lançamento",
                  book.publishedDate != null
                      ? "${book.publishedDate!.day}/${book.publishedDate!.month}/${book.publishedDate!.year}"
                      : "Sem Data",
                ),
                const SizedBox(height: 10),
                _detail(
                  "Páginas",
                  book.pageCount?.toString() ?? "",
                ),
                const SizedBox(height: 10),
                _detail(
                  "Idioma",
                  book.language?.toString() ?? "",
                ),
                const SizedBox(height: 10),
                _detail(
                  "Gêneros",
                  book.genresString,
                ),
                const SizedBox(height: 10),
                _detail(
                  "Editora",
                  book.publisher?.toString() ?? "Sem Informação",
                ),
                const SizedBox(height: 10),
                _detail(
                  "ISBN-10",
                  book.isbn10 ?? "",
                ),
                const SizedBox(height: 10),
                _detail(
                  "ISBN-13",
                  book.isbn13 ?? "",
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
