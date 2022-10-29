import 'package:livrodin/components/confirm_dialog.dart';
import 'package:livrodin/components/rate_dialog.dart';
import 'package:livrodin/components/toggle_offer_status.dart';
import 'package:livrodin/services/book_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../models/book.dart';
import 'auth_controller.dart';

class BookController extends GetxController {
  var authController = Get.find<AuthController>();
  var bookService = BookService();

  Future<bool?> makeBookAvailable(Book book, OfferStatus offerStatus) async {
    try {
      // call a dialog
      bool hasAdded = await Get.dialog(ConfirmDialog(
        title: 'Confirmar?',
        content:
            'Você está preste a adicionar o livro: “${book.title}” para a Doação.',
        onConfirm: () async {
          bookService
              .addBook(book, offerStatus)
              .whenComplete(() => Get.back(result: true));
        },
      ));
      if (hasAdded) {
        await Get.dialog(RateDialog(
          title: 'Avalie o livro',
          onConfirm: ({required rate, required comment}) async {
            await bookService
                .addRate(book: book, rate: rate, comment: comment)
                .whenComplete(() => Get.back());
          },
        ));
      }

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

  Future<List<Book>> getAvailableBooks({int? limit, int? page}) async {
    try {
      var result =
          await bookService.getAvailableBooks(limit: limit, page: page);
      return result;
    } catch (e) {
      printError(info: e.toString());
      return [];
    }
  }
}
