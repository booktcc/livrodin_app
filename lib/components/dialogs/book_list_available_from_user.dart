import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/cards/book_card.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/controllers/user_book_available_controller.dart';
import 'package:livrodin/models/user.dart';

class BookListAvailableFromUser extends StatefulWidget {
  final User user;

  const BookListAvailableFromUser({super.key, required this.user});

  @override
  State<BookListAvailableFromUser> createState() =>
      _BookListAvailableFromUserState();
}

class _BookListAvailableFromUserState extends State<BookListAvailableFromUser> {
  late UserBookAvailableController _userBookAvailable;

  @override
  void initState() {
    super.initState();
    _userBookAvailable =
        Get.put(UserBookAvailableController(user: widget.user));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Selecione um livro'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: lightGrey,
      content: Obx(
        () => SizedBox(
          width: 300,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: _userBookAvailable.availabilityList
                  .map((e) => BookCard(
                        book: e.book,
                        onTap: (_) {
                          Get.back(result: e);
                        },
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
