import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/cards/book_card.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/auth_controller.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/models/interest.dart';

class UserListInterestDialig extends StatelessWidget {
  UserListInterestDialig({super.key});

  final authController = Get.find<AuthController>();
  final bookController = Get.find<BookController>();

  @override
  Widget build(BuildContext context) {
    return Layout(
      headerProps: HeaderProps(
        showLogo: false,
        showBackButton: true,
        title: 'Lista de Interesse',
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
            future: bookController.getInterestsList(),
            builder: (context, AsyncSnapshot<List<Interest>> snapshot) {
              if (snapshot.hasData) {
                final interests = snapshot.data!;
                if (interests.isEmpty) {
                  return const Center(
                    child: Text('Nenhum livro na lista de interesse'),
                  );
                } else {
                  return CustomScrollView(
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
                            childAspectRatio: 0.7,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return BookCard(
                                book: interests[index].book,
                                onTap: (_) => Get.toNamed(
                                  "/book/detail/${interests[index].book.id}",
                                ),
                              );
                            },
                            childCount: interests.length,
                          ),
                        ),
                      ),
                    ],
                  );
                }
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
