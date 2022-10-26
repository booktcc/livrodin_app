import 'package:app_flutter/components/cards/book_card.dart';
import 'package:app_flutter/components/header.dart';
import 'package:app_flutter/components/layout.dart';
import 'package:app_flutter/components/input.dart';
import 'package:app_flutter/components/toggle_offer_status.dart';
import 'package:app_flutter/configs/themes.dart';
import 'package:app_flutter/controllers/book_controller.dart';
import 'package:app_flutter/models/book.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SearchStatus { initial, loading, complete, error }

class BookAvailabilityPage extends StatefulWidget {
  const BookAvailabilityPage({Key? key}) : super(key: key);

  @override
  State<BookAvailabilityPage> createState() => _BookAvailabilityPageState();
}

class _BookAvailabilityPageState extends State<BookAvailabilityPage> {
  OfferStatus _status = OfferStatus.both;
  final BookController _bookController = Get.find<BookController>();

  List<Book> _searchedBooks = [];
  final Rx<SearchStatus> _searchStatus = Rx(SearchStatus.initial);
  @override
  Widget build(BuildContext context) {
    return Layout(
      headerProps: HeaderProps(
        showLogo: false,
        showBackButton: true,
        title: 'Disponibilizar livro',
      ),
      child: Ink(
        decoration: const BoxDecoration(
          color: lightGrey,
        ),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 24),
            ToggleOfferStatus(
              status: _status,
              onChange: (status) => _status = status,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Input(
                hintText: "Pesquise por título ou ISBN",
                leftIcon: const Icon(Icons.search, color: Colors.grey),
                rightIcon: GestureDetector(
                  child: const Icon(Icons.qr_code_rounded, color: Colors.black),
                  onTap: () {
                    debugPrint("onTap");
                  },
                ),
                onEditingComplete: (String text) async {
                  _searchedBooks = await _bookController.searchBook(text);
                  _searchStatus.value = SearchStatus.complete;
                },
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                if (_searchStatus.value == SearchStatus.initial) {
                  return const SizedBox();
                } else if (_searchStatus.value == SearchStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (_searchStatus.value == SearchStatus.complete) {
                  return CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return BookCard(
                                book: _searchedBooks[index],
                                onTap: (book) {
                                  _bookController.makeBookAvailable(
                                      book, _status);
                                },
                              );
                            },
                            childCount: _searchedBooks.length,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: Text("Erro ao pesquisar"),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
