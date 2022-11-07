import 'package:livrodin/components/cards/transaction_card.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:flutter/material.dart';

import '../utils/fake_data.dart';

class TransactionCardStories extends StatelessWidget {
  const TransactionCardStories({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: Center(
          child: TransactionCard(
        transaction: fakeTransaction,
        onMessagePressed: () {},
        onConfirmPressed: () {},
        onCancelPressed: () {},
      )),
    );
  }
}
