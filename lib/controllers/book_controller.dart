import 'package:app_flutter/components/confirm_dialog.dart';
import 'package:app_flutter/components/rate_dialog.dart';
import 'package:app_flutter/components/toggle_offer_status.dart';
import 'package:app_flutter/services/book_service.dart';
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
          // await bookService.addBook(book, offerStatus);
          // close the dialog
          Get.back();
        },
      ));

      await Get.dialog(RateDialog(
        title: 'Avalie o livro',
        content: "Dê sua nota",
        onConfirm: (rate) {
          // update the book rate
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
      var result = await bookService.searchBooksOnGoogleApi(q);
      return result;
    } catch (e) {
      printError(info: e.toString());
      return [];
    }
  }
}
