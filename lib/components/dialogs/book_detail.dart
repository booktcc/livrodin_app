import 'package:flutter/material.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/models/book.dart';

class BookDetailDialog extends StatefulWidget {
  const BookDetailDialog({super.key, required Book book}) : _book = book;

  final Book _book;

  @override
  State<BookDetailDialog> createState() => _BookDetailDialogState();
}

class _BookDetailDialogState extends State<BookDetailDialog> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      headerProps: HeaderProps(
        showLogo: true,
        showBackButton: true,
      ),
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          final double minSize =
              (boxConstraints.maxHeight - 240) / boxConstraints.maxHeight;
          return Stack(
            children: [
              // HomeBanner(
              //   books: const [],
              // ),
              DraggableScrollableSheet(
                initialChildSize: minSize,
                maxChildSize: 1,
                minChildSize: minSize,
                builder: (context, scrollController) => ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(pageRadius),
                  ),
                  child: Container(
                    color: lightGrey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  widget._book.title!,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                  "J.K. Rowling".toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                  ),
                                  Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                  ),
                                  Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                  ),
                                  Icon(
                                    Icons.star_rounded,
                                    color: Colors.amber,
                                  ),
                                  Icon(
                                    Icons.star_half_rounded,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "4.5",
                                    style: TextStyle(
                                        color: Colors.amber,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Flexible(
                          child: DefaultTabController(
                            length: 4,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const TabBar(
                                  isScrollable: true,
                                  tabs: [
                                    Tab(
                                      child: Text(
                                        "Sinopse",
                                        maxLines: 1,
                                        style: TextStyle(color: dark),
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        "Detalhes",
                                        maxLines: 1,
                                        style: TextStyle(color: dark),
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        "Avaliações",
                                        maxLines: 1,
                                        style: TextStyle(color: dark),
                                      ),
                                    ),
                                    Tab(
                                      child: Text(
                                        "Discussões",
                                        maxLines: 1,
                                        style: TextStyle(color: dark),
                                      ),
                                    ),
                                  ],
                                ),
                                Flexible(
                                  child: TabBarView(
                                    children: [
                                      CustomScrollView(
                                        controller: scrollController,
                                        slivers: [],
                                      ),
                                      CustomScrollView(
                                        controller: scrollController,
                                        slivers: [],
                                      ),
                                      CustomScrollView(
                                        controller: scrollController,
                                        slivers: [],
                                      ),
                                      CustomScrollView(
                                        controller: scrollController,
                                        slivers: [],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
