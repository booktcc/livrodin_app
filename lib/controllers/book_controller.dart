import 'package:livrodin/components/confirm_dialog.dart';
import 'package:livrodin/components/rate_dialog.dart';
import 'package:livrodin/components/toggle_offer_status.dart';
import 'package:livrodin/services/book_service.dart';
import 'package:get/get.dart';

import '../models/book.dart';
import 'auth_controller.dart';

class BookController extends GetxController {
  var authController = Get.find<AuthController>();
  var bookService = Get.find<BookService>();

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
            rateBook(book: book, rate: rate, comment: comment)
                .whenComplete(() => Get.back());
          },
        ));
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool?> rateBook(
      {required Book book, required rate, required comment}) async {
    try {
      await bookService.addRate(book: book, rate: rate, comment: comment);
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

  Future<Book> getBookById(String id) async {
    try {
      var result = await bookService.searchBooksOnGoogleApi(id);
      return result[0];
    } catch (e) {
      printError(info: e.toString());
      rethrow;
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

  // fecth book rating
  Future<void> fetchBookRating(Book book) async {
    try {
      var result = await bookService.getBookRating(book.id);
      book.ratings = result;
      // return result;
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }
}
