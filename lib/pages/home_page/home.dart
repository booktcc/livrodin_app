import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/cards/book_card.dart';
import 'package:livrodin/components/home_banner.dart';
import 'package:livrodin/components/title.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/models/book.dart';
import 'package:livrodin/utils/state_machine.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final RxList<Book> books = <Book>[].obs;
  final RxList<Book> booksRecommend = <Book>[].obs;
  final Rx<FetchState> stateFetchRecomend = Rx(FetchState.loading);
  final BookController _bookController = Get.find<BookController>();
  final Rx<FetchState> stateFetch = FetchState.loading.obs;

  @override
  void initState() {
    super.initState();
    stateFetch.value = FetchState.loading;
    _bookController.getAvailableBooks().then((value) {
      books.value = value;
      stateFetch.value = FetchState.success;
    }).onError((error, stackTrace) {
      stateFetch.value = FetchState.error;
    });

    stateFetchRecomend.value = FetchState.loading;
    _bookController.getRecomendBooks().then((value) {
      booksRecommend.value = value;
      stateFetchRecomend.value = FetchState.success;
    }).onError((error, stackTrace) {
      stateFetchRecomend.value = FetchState.error;
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
            Obx(() {
              if (stateFetch.value == FetchState.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (stateFetch.value == FetchState.error) {
                return const Center(
                  child: Text('Erro ao carregar livros'),
                );
              } else if (books.isEmpty) {
                return const Center(
                  child: Text('Nenhum livro disponível'),
                );
              } else {
                return HomeBanner(
                  books: books.sublist(0, books.length > 5 ? 5 : books.length),
                );
              }
            }),
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
                    physics: const BouncingScrollPhysics(),
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
                            height: 250,
                            child: Obx(
                              () {
                                if (stateFetch.value == FetchState.success) {
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
                                          onTap: (book) => Get.toNamed(
                                            "/book/detail/${book.id}",
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else if (stateFetch.value ==
                                    FetchState.loading) {
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
                        sliver: Obx(() {
                          if (stateFetch.value == FetchState.success) {
                            return SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 10,
                                childAspectRatio: 0.73,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return BookCard(
                                    book: booksRecommend[index],
                                    onTap: (_) => Get.toNamed(
                                      "/book/detail/${booksRecommend[index].id}",
                                    ),
                                  );
                                },
                                childCount: booksRecommend.length,
                              ),
                            );
                          } else if (stateFetch.value == FetchState.loading) {
                            return const SliverFillRemaining(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return const SliverFillRemaining(
                            child: Center(
                              child: Text("Erro ao carregar livros"),
                            ),
                          );
                        }),
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
