import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/cards/book_card.dart';
import 'package:livrodin/components/cards/genrer_card.dart';
import 'package:livrodin/components/filter_option.dart';
import 'package:livrodin/components/title.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/models/Genrer.dart';
import 'package:livrodin/models/book.dart';

enum GenrerStatus { loading, success, error }

class GenrerView extends StatefulWidget {
  const GenrerView({super.key});

  @override
  State<GenrerView> createState() => _GenrerViewState();
}

class _GenrerViewState extends State<GenrerView> {
  final BookController bookController = Get.find<BookController>();

  final Rx<Genrer?> _selected = Rx(null);

  final Rx<GenrerStatus> _status = Rx(GenrerStatus.loading);

  List<Book> booksSeached = [];
  final Rx<bool> _donate = Rx(false);
  final Rx<bool> _trade = Rx(false);
  List<Book> booksFiltered = [];
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(pageRadius),
      ),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: lightGrey,
        ),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            _page1(),
            _page2(),
          ],
        ),
      ),
    );
  }

  Widget _page1() {
    return Column(
      children: [
        const PageTitle(
          title: "Gêneros",
        ),
        Expanded(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              Obx(() {
                if (bookController.genres.value.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return SliverPadding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                      bottom: 100,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return GenrerCard(
                            onTap: (genrer) {
                              _selected.value = genrer;
                              _status.value = GenrerStatus.loading;
                              bookController
                                  .searchBook("subject:${genrer.id}",
                                      maxResults: 10, isAvailable: true)
                                  .then((value) {
                                booksSeached = value;
                                booksFiltered = value;
                                _status.value = GenrerStatus.success;
                              }, onError: (error) {
                                _status.value = GenrerStatus.error;
                              });
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            genrer: bookController.genres.value[index],
                          );
                        },
                        childCount: bookController.genres.value.length,
                      ),
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _page2() {
    return Obx(() {
      if (_status.value == GenrerStatus.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (_status.value == GenrerStatus.error) {
        return const Center(
          child: Text("Erro ao carregar os livros"),
        );
      } else {
        return Column(
          children: [
            PageTitle(
              title: "Gênero > ${_selected.value?.name}",
            ),
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          FilterOption(
                            title: "Doação",
                            selected: _donate.value,
                            onTap: () {
                              _donate.value = !_donate.value;
                              changeFilter();
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          FilterOption(
                            title: "Troca",
                            selected: _trade.value,
                            onTap: () {
                              _trade.value = !_trade.value;
                              changeFilter();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 10,
                      right: 10,
                      bottom: 100,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.7,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return BookCard(
                            book: booksFiltered[index],
                            onTap: (_) => Get.toNamed(
                              "/book/detail/${booksFiltered[index].id}",
                            ),
                          );
                        },
                        childCount: booksFiltered.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    });
  }

  void changeFilter() {
    _status.value = GenrerStatus.loading;
    if (!_donate.value && !_trade.value) {
      booksFiltered = booksSeached;
    } else if (_donate.value && !_trade.value) {
      booksFiltered = booksSeached
          .where((element) =>
              element.availableType == BookAvailableType.donate ||
              element.availableType == BookAvailableType.both)
          .toList();
    } else if (!_donate.value && _trade.value) {
      booksFiltered = booksSeached
          .where((element) =>
              element.availableType == BookAvailableType.trade ||
              element.availableType == BookAvailableType.both)
          .toList();
    } else {
      booksFiltered = booksSeached
          .where((element) => element.availableType != null)
          .toList();
    }
    _status.value = GenrerStatus.success;
  }
}
