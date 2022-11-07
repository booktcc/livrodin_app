import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:livrodin/controllers/book_controller.dart';
import 'package:livrodin/models/message.dart';
import 'package:livrodin/models/transaction.dart';

class MessagesController extends GetxController {
  final Transaction transaction;
  MessagesController({required this.transaction});

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final messages = <Message>[].obs;

  final BookController _bookController = Get.find<BookController>();

  final TextEditingController textInputController =
      TextEditingController(text: "");

  @override
  void onInit() {
    super.onInit();
    _getMessages();
  }

  void _getMessages() {
    final users = [transaction.user1, transaction.user2];
    firestore
        .collection('Transaction')
        .doc(transaction.id)
        .collection('Messages')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .listen((event) {
      messages.value = event.docs.map((e) {
        var user = users.firstWhere((element) => element.id == e['userId']);
        return Message.fromJson(e.data(), user, e.id);
      }).toList();
    });
  }

  void sendMessage() {
    _bookController.sendTransactionMessage(
        transaction.id, textInputController.text);
    textInputController.clear();
  }
}