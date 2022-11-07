import 'package:flutter/material.dart';
import 'package:livrodin/components/dialogs/transaction_chat.dart';

import '../utils/fake_data.dart';

class TransactionChatStories extends StatelessWidget {
  const TransactionChatStories({super.key});

  @override
  Widget build(BuildContext context) {
    return TransactionChat(
      transaction: fakeTransaction,
    );
  }
}
