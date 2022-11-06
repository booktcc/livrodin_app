import 'package:livrodin/components/cards/transaction_card.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:flutter/material.dart';
import 'package:livrodin/models/availability.dart';
import 'package:livrodin/models/book.dart';
import 'package:livrodin/models/transaction.dart';
import 'package:livrodin/models/user.dart';

import '../utils/fake_data.dart';

class TransactionCardStories extends StatelessWidget {
  const TransactionCardStories({super.key});

  @override
  Widget build(BuildContext context) {
    var user1 = User(
      id: "",
      name: "João Lucas",
      profilePictureUrl: "https://avatars.githubusercontent.com/u/55464917?v=4",
      isMe: true,
    );

    var user2 = User(
      id: "",
      name: "Higor",
      profilePictureUrl: "https://avatars.githubusercontent.com/u/47704204?v=4",
    );

    var fakeBook = Book(
      id: "",
      coverUrl: fakeBookImage,
    );

    return Scaffold(
      backgroundColor: lightGrey,
      body: Center(
          child: TransactionCard(
        transaction: Transaction(
          id: "",
          availability: Availability(
            id: "",
            book: fakeBook,
            user: user1,
            dateAvailable: DateTime.now(),
            availableType: BookAvailableType.trade,
          ),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          type: BookAvailableType.trade,
          status: TransactionStatus.pending,
          user1: user1,
          user2: user2,
        ),
        onMessagePressed: () {},
        onConfirmPressed: () {},
        onCancelPressed: () {},
      )),
    );
  }
}
