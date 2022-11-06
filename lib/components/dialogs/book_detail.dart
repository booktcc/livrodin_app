import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_action.dart';
import 'package:livrodin/components/dialogs/book_list_available.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/components/rating_info.dart';
import 'package:livrodin/components/tabs/book_detail/details.dart';
import 'package:livrodin/components/tabs/book_detail/discussions.dart';
import 'package:livrodin/components/tabs/book_detail/ratings.dart';
import 'package:livrodin/components/tabs/book_detail/synopsis.dart';
import 'package:livrodin/configs/livrodin_icons.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/models/availability.dart';
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
  final RxList<Availability> _bookAvailabilityList = <Availability>[].obs;

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
        _bookController.getBookByIdGoogle(widget._book.id).then((value) {
          widget._book = value;
          _bookStatus.value = BookStatus.loaded;

          _bookRatingStatus.value = BookRatingStatus.loading;
          _bookController.fetchBookRating(value).then(
              (_) => _bookRatingStatus.value = BookRatingStatus.loaded,
              onError: (_) => _bookRatingStatus.value = BookRatingStatus.error);
          // _bookController.fetchBookDiscussions(value).then((value) => {
          _bookController.getBookAvailabityById(value.id).then((value) {
            _bookAvailabilityList.value = value;
          }, onError: (_) {});
          // });
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    RatingInfo(
                                      rating: widget._book.averageRating,
                                      isLoading: _bookRatingStatus.value ==
                                              BookDiscussionStatus.loading
                                          ? true
                                          : false,
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
                                      TabBar(
                                        enableFeedback: true,
                                        labelColor: dark,
                                        labelStyle: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                        unselectedLabelStyle: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                        isScrollable: true,
                                        tabs: [
                                          const Tab(text: "Sinopse"),
                                          const Tab(text: "Detalhes"),
                                          Tab(
                                              text:
                                                  "Avaliações (${widget._book.ratings.length})"),
                                          const Tab(text: "Discussões"),
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
                                              book: widget._book,
                                              bookRatingStatus:
                                                  _bookRatingStatus,
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
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonAction(
                          onPressed: () {},
                          color: Colors.white,
                          icon: Icons.bookmark_add,
                          iconSize: 24,
                          radius: 360,
                          minHeight: 40,
                          minWidth: 40,
                          textColor: grey,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: widget._book.availableType ==
                                  BookAvailableType.donate,
                              child: ButtonAction(
                                onPressed: () =>
                                    Get.dialog(const BookListAvailable()),
                                label: "PEDIR",
                                icon: LivrodinIcons.donateIcon,
                              ),
                            ),
                            Visibility(
                              visible: widget._book.availableType ==
                                      BookAvailableType.donate &&
                                  widget._book.availableType ==
                                      BookAvailableType.trade,
                              child: const SizedBox(width: 30),
                            ),
                            Visibility(
                              visible: widget._book.availableType ==
                                  BookAvailableType.trade,
                              child: ButtonAction(
                                onPressed: () =>
                                    Get.dialog(const BookListAvailable()),
                                label: "TROCAR",
                                icon: Icons.swap_horizontal_circle,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
