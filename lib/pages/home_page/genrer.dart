import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/cards/genrer_card.dart';
import 'package:livrodin/components/title.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/book_controller.dart';

class Genrer extends StatelessWidget {
  Genrer({super.key});

  final BookController bookController = Get.find<BookController>();
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
        child: Column(
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
        ),
      ),
    );
  }
}
