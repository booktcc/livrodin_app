import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/components/rating_info.dart';
import 'package:livrodin/components/tabs/book_detail/details.dart';
import 'package:livrodin/components/tabs/book_detail/discussions.dart';
import 'package:livrodin/components/tabs/book_detail/ratings.dart';
import 'package:livrodin/components/tabs/book_detail/synopsis.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/models/book.dart';

enum BookStatus { init, loading, loaded, error }

enum BookRatingStatus { init, loading, loaded, error }

enum BookDiscussionStatus { init, loading, loaded, error }

class BookDetailDialog extends StatefulWidget {
  BookDetailDialog({super.key, required Book book}) : _book = book;

  Book _book;

  @override
  State<BookDetailDialog> createState() => _BookDetailDialogState();
}

class _BookDetailDialogState extends State<BookDetailDialog> {
  final BookController _bookController = Get.find<BookController>();
  final Rx<BookStatus> _bookStatus = BookStatus.init.obs;
  final Rx<BookRatingStatus> _bookRatingStatus = BookRatingStatus.init.obs;
  final Rx<BookDiscussionStatus> _bookDiscussionStatus =
      BookDiscussionStatus.init.obs;

  @override
  void initState() {
    if (widget._book.synopsis != null ||
        widget._book.genres != null ||
        widget._book.isbn10 != null ||
        widget._book.isbn13 != null) {
      _bookStatus.value = BookStatus.loaded;
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_bookStatus.value == BookStatus.init) {
        _bookStatus.value = BookStatus.loading;
        _bookController.getBookById(widget._book.id).then((value) {
          widget._book = value;
          _bookStatus.value = BookStatus.loaded;
        }).catchError((error) {
          _bookStatus.value = BookStatus.error;
        });
      }
    });

    super.initState();
  }

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
              SizedBox(
                height: 240,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: LayoutBuilder(builder: (context, constraints) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          widget._book.coverUrl!,
                          fit: BoxFit.cover,
                          height: constraints.maxHeight,
                          width: (constraints.maxHeight * 240) / 360,
                        ),
                      );
                    }),
                  ),
                ),
              ),
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
                    child: Obx(
                      () {
                        if (_bookStatus.value == BookStatus.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (_bookStatus.value == BookStatus.error) {
                          return const Center(
                            child: Text("Erro ao carregar o livro"),
                          );
                        } else {
                          return Column(
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
                                    Text(
                                      widget._book.title!,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      widget._book.authorsString.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    const RatingInfo(
                                      rating: 3.5,
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
                                        enableFeedback: true,
                                        labelColor: dark,
                                        isScrollable: true,
                                        tabs: [
                                          Tab(text: "Sinopse"),
                                          Tab(text: "Detalhes"),
                                          Tab(text: "Avaliações (0)"),
                                          Tab(text: "Discussões"),
                                        ],
                                      ),
                                      Flexible(
                                        child: TabBarView(
                                          children: [
                                            TabViewSynopsis(
                                              book: widget._book,
                                              scrollController:
                                                  scrollController,
                                            ),
                                            TabViewDetails(
                                              book: widget._book,
                                              scrollController:
                                                  scrollController,
                                            ),
                                            TabViewRatings(
                                              scrollController:
                                                  scrollController,
                                            ),
                                            TabViewDiscussions(
                                              scrollController:
                                                  scrollController,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
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
