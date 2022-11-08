import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/cards/book_card.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/models/book.dart';
import 'package:livrodin/utils/state_machine.dart';

//  delegate only redirect to search page passing parameters
class SearchBookDelegate extends SearchDelegate<String> {
  SearchBookDelegate();

  final BookController bookController = Get.find<BookController>();

  List<Book> booksSearched = [];

  final Rx<FetchState> _status = Rx(FetchState.success);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  var isRedirecting = false;

  @override
  Widget buildResults(BuildContext context) {
    _status.value = FetchState.loading;
    bookController.searchBook(query, maxResults: 20).then((value) {
      booksSearched = value;
      _status.value = FetchState.success;
    }).catchError((error) {
      _status.value = FetchState.error;
    });
    return Obx(() {
      if (_status.value == FetchState.loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (_status.value == FetchState.error) {
        return const Center(
          child: Text("Erro ao carregar os livros"),
        );
      } else {
        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(10),
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
                            book: booksSearched[index],
                            onTap: (_) => Get.toNamed(
                              "/book/detail/${booksSearched[index].id}",
                            ),
                          );
                        },
                        childCount: booksSearched.length,
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

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  String get searchFieldLabel => 'Pesquisar livro';
}
