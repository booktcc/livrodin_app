import 'package:app_flutter/components/confirm_dialog.dart';
import 'package:app_flutter/components/toggle_offer_status.dart';
import 'package:app_flutter/services/book_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/book.dart';
import 'auth_controller.dart';

class BookController extends GetxController {
  var authController = Get.find<AuthController>();
  var bookService = BookService();

  Future<bool?> makeBookAvailable(Book book, OfferStatus offerStatus) async {
    try {
      // call a dialog
      await Get.dialog(ConfirmDialog(
        title: 'Confirmar?',
        content:
            'Você está preste a adicionar o livro: “${book.title}” para a Doação.',
        onConfirm: () async {
          // update the book status
          await FirebaseFirestore.instance
              .collection("BookAvailable")
              .doc()
              .set({
            "idBook": book.isbn10 ?? book.isbn13,
            "idUser": authController.user.value!.uid,
            "data": DateTime.now().toIso8601String(),
            "forDonation": (offerStatus == OfferStatus.both ||
                offerStatus == OfferStatus.donate),
            "forTrade": (offerStatus == OfferStatus.both ||
                offerStatus == OfferStatus.trade),
          });
          // close the dialog
          Get.back();
        },
      ));

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Book>> searchBook(String q) async {
    try {
      var result = await bookService.searchBooks(q);
      return result;
    } catch (e) {
      printError(info: e.toString());
      return [];
    }
  }
}
