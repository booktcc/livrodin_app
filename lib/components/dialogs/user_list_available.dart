import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/cards/book_card.dart';
import 'package:livrodin/components/header.dart';
import 'package:livrodin/components/layout.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/models/availability.dart';

class UserListAvailableDialog extends StatelessWidget {
  UserListAvailableDialog({super.key});

  final bookController = Get.find<BookController>();

  @override
  Widget build(BuildContext context) {
    return Layout(
      headerProps: HeaderProps(
        showLogo: false,
        showBackButton: true,
        title: 'Livros Disponibilizados',
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
          child: FutureBuilder<List<Availability>>(
            future: bookController.getMadeAvailableList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final availabilities = snapshot.data!;
                if (availabilities.isEmpty) {
                  return const Center(
                    child: Text('Nenhum livro está sendo disponibilizado'),
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
                                book: availabilities[index].book,
                                onTap: (_) => Get.toNamed(
                                  "/book/detail/${availabilities[index].book.id}",
                                ),
                              );
                            },
                            childCount: availabilities.length,
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
