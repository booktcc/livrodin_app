import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/button_action.dart';
import 'package:livrodin/components/cards/rating_card.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/book_detail_controller.dart';
import 'package:livrodin/pages/book_detail_page.dart';

class TabViewRatings extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();

  TabViewRatings({
    super.key,
    required this.scrollController,
  });

  final BookDetailController _bookDetailController =
      Get.find<BookDetailController>();
  bool userComented = true;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_bookDetailController.bookRatingStatus.value ==
          BookRatingStatus.loaded) {
        try {
          userComented = _bookDetailController.book!.ratings.first.user.id ==
              _authController.user.value?.uid;
        } catch (e) {
          userComented = false;
        }
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
                                onPressed: _bookDetailController.addRate,
                                label: "Avaliar",
                              ),
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
                          RatingCard(
                              rating:
                                  _bookDetailController.book!.ratings.first),
                        ],
                      ),
              ),
            ),
            SliverVisibility(
              visible: !(_bookDetailController.book!.ratings.isEmpty ||
                  (userComented &&
                      _bookDetailController.book!.ratings.length == 1)),
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
                        ? _bookDetailController.book!.ratings.length - 1
                        : _bookDetailController.book!.ratings.length,
                    (index) => RatingCard(
                      rating: _bookDetailController
                          .book!.ratings[userComented ? index + 1 : index],
                      margin: const EdgeInsets.only(bottom: 10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      } else if (_bookDetailController.bookRatingStatus.value ==
          BookRatingStatus.error) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Ocorreu um erro ao carregar as avaliações"),
              ButtonAction(
                onPressed: _bookDetailController.reloadBookRating,
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
}
