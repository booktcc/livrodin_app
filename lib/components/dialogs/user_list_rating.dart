import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/cards/rating_card.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/models/book.dart';

class UserListRatingDialig extends StatelessWidget {
  UserListRatingDialig({super.key});

  final authController = Get.find<AuthController>();
  final bookController = Get.find<BookController>();

  @override
  Widget build(BuildContext context) {
    return Layout(
      headerProps: HeaderProps(
        showLogo: false,
        showBackButton: true,
        title: 'Livros Avaliados',
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(pageRadius),
          topRight: Radius.circular(pageRadius),
        ),
        child: Container(
          color: lightGrey,
          height: double.infinity,
          width: double.infinity,
          child: FutureBuilder(
            future: bookController.getBooksRatingByUser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final ratings = snapshot.data as List<Book>;
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(10),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () => Get.toNamed(
                                "/book/detail/${ratings[index].id}",
                              ),
                              child: RatingCard(
                                book: ratings[index],
                                margin: const EdgeInsets.only(bottom: 10),
                                rating: ratings[index].ratings[0],
                              ),
                            );
                          },
                          childCount: ratings.length,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
