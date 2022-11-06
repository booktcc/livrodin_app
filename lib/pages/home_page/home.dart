import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/cards/book_card.dart';
import 'package:livrodin/components/dialogs/book_detail.dart';
import 'package:livrodin/components/title.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/models/book.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

enum ResultBooksFetch { success, error, loading }

class _HomeState extends State<Home> {
  final RxList<Book> books = <Book>[].obs;

  final BookController _bookController = Get.find<BookController>();
  final Rx<ResultBooksFetch> result = ResultBooksFetch.loading.obs;

  @override
  void initState() {
    super.initState();
    result.value = ResultBooksFetch.loading;
    _bookController.getAvailableBooks().then((value) {
      books.value = value;
      result.value = ResultBooksFetch.success;
    }).onError((error, stackTrace) {
      result.value = ResultBooksFetch.error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: PageTitle(
                          title: "Últimos Disponibilizados",
                          actions: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.more_rounded),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        sliver: SliverToBoxAdapter(
                          child: SizedBox(
                            height: 222,
                            child: Obx(
                              () {
                                if (result.value == ResultBooksFetch.success) {
                                  return ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: books.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            left: index == 0 ? 20 : 0,
                                            right: 20),
                                        child: BookCard(
                                          book: books[index],
                                          onTap: (book) => Get.dialog(
                                            BookDetailDialog(
                                              book: book,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else if (result.value ==
                                    ResultBooksFetch.loading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return const Center(
                                  child: Text("Erro ao carregar livros"),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: PageTitle(
                          title: "Recomendados",
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 90, left: 20, right: 20),
                        sliver: SliverGrid.count(
                          childAspectRatio: 0.73,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 10,
                          crossAxisCount: 2,
                          children: List.generate(
                            10,
                            (index) => BookCard(
                              book: Book(
                                id: "1",
                                title: "O Senhor dos Anéis",
                                coverUrl:
                                    "https://books.google.com/books/content?id=GgQmDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
                              ),
                            ),
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
    );
  }
}
