import 'package:app_flutter/configs/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key});

  final double radius = 10;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Stack(
        fit: StackFit.loose,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(radius),
                onTap: () {},
                child: Ink(
                  width: double.infinity,
                  height: 160,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(radius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 0.1,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Ink(
                        height: constraints.maxHeight,
                        width: (constraints.maxHeight * 240) / 360,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(radius),
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://books.google.com.br/books/publisher/content?id=GjgQCwAAQBAJ&hl=pt-BR&pg=PP1&img=1&zoom=3&bul=1&sig=ACfU3U32CKE-XFfMvnbcz1qW0PS46Lg-Ew&w=1280"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Harry Potter e a Pedra Filosofal',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: grey,
                  fontFamily: "Avenir",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
          Align(
            heightFactor: 1,
            alignment: Alignment.topRight,
            child: IconButton(
              splashColor: Colors.transparent,
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_border,
                color: red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
