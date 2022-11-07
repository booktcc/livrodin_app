import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_action.dart';
import 'package:livrodin/components/cards/rating_card.dart';
import 'package:livrodin/components/dialogs/rate_dialog.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/models/book.dart';
import 'package:livrodin/pages/book_detail_page.dart';

class TabViewRatings extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
  final BookController _bookController = Get.find<BookController>();

  TabViewRatings({
    super.key,
    required this.scrollController,
    required this.book,
    required this.bookRatingStatus,
  }) {
    try {
      userComented =
          book.ratings.first.user.id == _authController.user.value?.uid;
    } catch (e) {
      userComented = false;
    }
  }

  late final bool userComented;
  final ScrollController scrollController;
  final Rx<BookRatingStatus> bookRatingStatus;
  final Book book;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (bookRatingStatus.value == BookRatingStatus.loaded) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          controller: scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverToBoxAdapter(
                child: (!userComented)
                    ? SizedBox(
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Já leu esse livro? Faça uma avaliação!',
                              ),
                              ButtonAction(
                                  onPressed: () async {
                                    await Get.dialog(RateDialog(
                                      title: 'Avalie o livro',
                                      onConfirm: (
                                          {required rate,
                                          required comment}) async {
                                        _bookController
                                            .rateBook(
                                                book: book,
                                                rate: rate,
                                                comment: comment)
                                            .whenComplete(() async {
                                          Get.back();
                                          _reloadBookRating();
                                        });
                                      },
                                    ));
                                  },
                                  label: "Avaliar"),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Minha Avaliação",
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 10),
                          RatingCard(rating: book.ratings.first),
                        ],
                      ),
              ),
            ),
            SliverVisibility(
              visible: !(book.ratings.isEmpty ||
                  (userComented && book.ratings.length == 1)),
              sliver: const SliverPadding(
                padding: EdgeInsets.only(left: 10, right: 10),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "Avaliações dos usuários",
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  List.generate(
                    userComented
                        ? book.ratings.length - 1
                        : book.ratings.length,
                    (index) => RatingCard(
                      rating: book.ratings[userComented ? index + 1 : index],
                      margin: const EdgeInsets.only(bottom: 10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      } else if (bookRatingStatus.value == BookRatingStatus.error) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Ocorreu um erro ao carregar as avaliações"),
              ButtonAction(
                onPressed: _reloadBookRating,
                label: "Tentar novamente",
              ),
            ],
          ),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }

  Future _reloadBookRating() async {
    bookRatingStatus.value = BookRatingStatus.loading;
    try {
      await _bookController.fetchBookRating(book);
      bookRatingStatus.value = BookRatingStatus.loaded;
    } catch (e) {
      bookRatingStatus.value = BookRatingStatus.error;
    }
  }
}
