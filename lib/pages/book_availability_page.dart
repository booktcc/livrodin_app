import 'package:livrodin/components/cards/book_card.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/components/input.dart';
import 'package:livrodin/components/toggle_offer_status.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/models/book.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

enum SearchStatus { initial, loading, complete, error }

class BookAvailabilityPage extends StatefulWidget {
  const BookAvailabilityPage({Key? key}) : super(key: key);

  @override
  State<BookAvailabilityPage> createState() => _BookAvailabilityPageState();
}

class _BookAvailabilityPageState extends State<BookAvailabilityPage> {
  BookAvailableType _status = BookAvailableType.both;
  final BookController _bookController = Get.find<BookController>();

  final Rx<SearchStatus> _searchStatus = Rx(SearchStatus.initial);
  final Rx<List<Book>> _searchedBooks = Rx([]);
  @override
  Widget build(BuildContext context) {
    return Layout(
      headerProps: HeaderProps(
        showLogo: false,
        showBackButton: true,
        title: 'Disponibilizar livro',
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(pageRadius),
            topRight: Radius.circular(pageRadius),
          ),
        ),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 24),
            ToggleOfferStatus(
              onChange: (status) => _status = status,
            ),
            Padding(
              padding: const EdgeInsets.only(
                right: 10,
                left: 10,
                top: 24,
                bottom: 10,
              ),
              child: Input(
                hintText: "Pesquise por título ou ISBN",
                leftIcon: const Icon(Icons.search, color: Colors.grey),
                rightIcon: GestureDetector(
                  child: const Icon(Icons.qr_code_rounded, color: Colors.black),
                  onTap: () async {
                    primaryFocus?.unfocus();
                    var result = await Get.dialog(
                      Layout(
                        headerProps: HeaderProps(
                          showBackButton: true,
                          showLogo: true,
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(pageRadius),
                          ),
                          child: MobileScanner(
                              allowDuplicates: false,
                              onDetect: (barcode, args) {
                                if (barcode.type == BarcodeType.isbn) {
                                  final String isbn = barcode.rawValue!;
                                  Get.back(result: isbn);
                                }
                              }),
                        ),
                      ),
                    );
                    if (result != null) {
                      _searchStatus.value = SearchStatus.loading;
                      var books =
                          await _bookController.searchBook("isbn:$result");

                      _searchedBooks.value = books;

                      _searchStatus.value = SearchStatus.complete;
                    }
                  },
                ),
                onEditingComplete: (String text) async {
                  _searchStatus.value = SearchStatus.loading;
                  var books = await _bookController.searchBook(text);
                  _searchedBooks.value = books;

                  _searchStatus.value = SearchStatus.complete;
                },
              ),
            ),
            Expanded(
              child: Obx(
                () {
                  if (_searchStatus.value == SearchStatus.initial) {
                    return const SizedBox();
                  } else if (_searchStatus.value == SearchStatus.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (_searchStatus.value == SearchStatus.complete) {
                    return CustomScrollView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
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
                                  book: _searchedBooks.value[index],
                                  onTap: (book) {
                                    _bookController.makeBookAvailable(
                                        book, _status);
                                  },
                                );
                              },
                              childCount: _searchedBooks.value.length,
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
