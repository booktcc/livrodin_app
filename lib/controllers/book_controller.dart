import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livrodin/components/confirm_dialog.dart';
import 'package:livrodin/components/dialogs/rate_dialog.dart';
import 'package:livrodin/configs/themes.dart';
import 'package:livrodin/models/Genrer.dart';
import 'package:livrodin/models/availability.dart';
import 'package:livrodin/models/book.dart';
import 'package:livrodin/models/discussion.dart';
import 'package:livrodin/models/interest.dart';
import 'package:livrodin/models/reply.dart';
import 'package:livrodin/models/transaction.dart';
import 'package:livrodin/services/book_service.dart';

import 'auth_controller.dart';

class BookController extends GetxController {
  var authController = Get.find<AuthController>();
  var bookService = Get.find<BookService>();
  Rx<List<Genrer>> genres = Rx([]);

  @override
  void onInit() {
    fetchGenres();
    super.onInit();
  }

  Future<bool?> makeBookAvailable(
      Book book, BookAvailableType offerStatus) async {
    try {
      // call a dialog
      bool hasAdded = await Get.dialog(ConfirmDialog(
        title: 'Confirmar?',
        content:
            'Você está preste a adicionar o livro: “${book.title}” para a Doação.',
        onConfirm: () async {
          bookService
              .addBookAvailable(book, offerStatus)
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

  Future<void> fetchGenres() async {
    try {
      genres.value = await bookService.getGenres();
    } catch (e) {
      genres.value = [];
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

  Future<Book> getBookOnGoogleApi(String bookId) async {
    try {
      var result = await bookService.getBookOnGoogleApi(bookId);
      return result;
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<List<Book>> getBooksRatingByUser() async {
    try {
      var result = await bookService.getBooksRatingByUser();
      return result;
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<List<Availability>> getMadeAvailableList() async {
    try {
      var result = await bookService.getMadeAvailableList();
      return result;
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

  Future<void> fetchBookRating(Book book) async {
    try {
      var result = await bookService.getBookRating(book.id);
      book.ratings = result;
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<List<Interest>> getInterestsList() async {
    try {
      var result = await bookService.getInterestList();
      return result;
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<List<Availability>> getBookAvailabityById(String id) async {
    try {
      var result = await bookService.getBookAvailabityById(id);
      return result;
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<bool?> createDiscussion({
    required Book book,
    required Discussion discussion,
  }) async {
    try {
      await bookService.addDiscussion(book: book, discussion: discussion);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> requestBook(
      String availabilityId, TransactionType transactionType) {
    try {
      return bookService
          .requestBook(availabilityId, transactionType)
          .then(
            (_) => Get.snackbar(
              "Livro Requisitado",
              "O livro foi requisitado com sucesso! Aguarde a resposta do dono do livro.",
              backgroundColor: green,
              colorText: Colors.white,
            ),
          )
          .catchError(
            (e) => Get.snackbar(
              "Erro",
              e.toString(),
              backgroundColor: red,
              colorText: Colors.white,
            ),
          );
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<List<Transaction>> getTransactionsFromUser() async {
    try {
      var result = await bookService.getTransactionsFromUser();
      return result;
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<void> fetchBookDiscussions(Book book) async {
    try {
      final result = await bookService.getBookDiscussions(book);
      book.discussions = result;
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<void> confirmTransaction(
      String transactionId, String? availability2Id) async {
    return bookService.confirmTransaction(transactionId, availability2Id).then(
      (_) {
        Get.snackbar(
          "Transação Confirmada",
          "A transação foi confirmada com sucesso!",
          backgroundColor: green,
          colorText: Colors.white,
        );
      },
    ).catchError(
      (e) {
        Get.snackbar(
          "Erro",
          e.toString(),
          backgroundColor: red,
          colorText: Colors.white,
        );
      },
    );
  }

  Future<void> completeTransaction(String transactionId) async {
    return bookService.completeTransaction(transactionId).then(
      (message) {
        Get.snackbar(
          "Sucesso",
          message,
          backgroundColor: green,
          colorText: Colors.white,
        );
      },
    ).catchError(
      (e) {
        Get.snackbar(
          "Erro",
          e.toString(),
          backgroundColor: red,
          colorText: Colors.white,
        );
      },
    );
  }

  Future<void> cancelTransaction(String transactionId) async {
    return bookService.cancelTransaction(transactionId).then(
      (_) {
        Get.snackbar(
          "Transação Cancelada",
          "A transação foi cancelada com sucesso!",
          backgroundColor: green,
          colorText: Colors.white,
        );
      },
    ).catchError(
      (e) {
        Get.snackbar(
          "Erro",
          e.toString(),
          backgroundColor: red,
          colorText: Colors.white,
        );
      },
    );
  }

  Future<void> rejectTransaction(String transactionId) async {
    return bookService.cancelTransaction(transactionId).then(
      (_) {
        Get.snackbar(
          "Transação Rejeitada",
          "A transação foi rejeitada com sucesso!",
          backgroundColor: green,
          colorText: Colors.white,
        );
      },
    ).catchError(
      (e) {
        Get.snackbar(
          "Erro",
          e.toString(),
          backgroundColor: red,
          colorText: Colors.white,
        );
      },
    );
  }

  Future<void> sendTransactionMessage(
      String transactionId, String message) async {
    return bookService
        .sendTransactionMessage(transactionId, message)
        .catchError(
      (e) {
        Get.snackbar(
          "Erro",
          e.toString(),
          backgroundColor: red,
          colorText: Colors.white,
        );
      },
    );
  }

  Future<void> fetchBookDiscussionsReplis(Discussion discussion) async {
    try {
      final result = await bookService.getDiscussionReplies(discussion);
      discussion.replies = result;
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }

  Future<void> createDiscussionReply({
    required Book book,
    required Reply reply,
    required Discussion parentDiscussion,
  }) async {
    try {
      await bookService.createDiscussionReply(
        book: book,
        reply: reply,
        parentDiscussion: parentDiscussion,
      );
    } catch (e) {
      printError(info: e.toString());
      rethrow;
    }
  }
}
