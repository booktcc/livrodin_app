import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: interests.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(interests[index].book.title!),
                        subtitle: Text(
                          interests[index].book.coverUrl!,
                        ),
                      );
                    },
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
