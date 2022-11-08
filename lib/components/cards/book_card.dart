import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/models/book.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key, this.onTap, required this.book});

  final Book book;
  final Function(Book)? onTap;
  final double radius = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              onTap: () => onTap?.call(book),
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
                        image: DecorationImage(
                          image: NetworkImage(book.coverUrl ??
                              "https://books.google.com/books/content?id=GgQmDwAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            book.title!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: grey,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Visibility(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: book.availableType == BookAvailableType.both ||
                      book.availableType == BookAvailableType.donate,
                  child: Icon(
                    Icons.handshake_rounded,
                    color: Colors.green[600],
                  ),
                ),
                Visibility(
                  visible: book.availableType == BookAvailableType.both ||
                      book.availableType == BookAvailableType.trade,
                  child: Icon(
                    Icons.swap_horizontal_circle_rounded,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
